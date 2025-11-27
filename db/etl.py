"""
ETL from Access `.accdb` -> SQLite `db/Estimating.db`.

Rules applied:
...
"""

import argparse
import json
import re
import sqlite3
import sys
from collections import defaultdict
from datetime import datetime
from typing import Any, Dict, List, Optional, Tuple

try:
	import pyodbc
except Exception as e:
	print("pyodbc is required to read Access .accdb files. Install it (pip install pyodbc) and ensure an Access ODBC driver is available.")
	raise

ACCDB_PATH = "db/Estimating.accdb"
SQLITE_PATH = "db/Estimating.db"


def transform_name(name: str) -> str:
	if not name:
		return name
	# Remove leading tbl (case-insensitive)
	name2 = re.sub(r'(?i)^tbl', '', name)
	# Replace Island -> Region (case-sensitive replacement of word fragment)
	name2 = name2.replace('Island', 'Region')
	return name2


def transform_default(default: Optional[str]) -> Optional[str]:
	if not default:
		return None
	# Strip surrounding = and spaces
	d = default.strip()
	if d.startswith('='):
		d = d[1:].strip()
	# common Access now() style: New() or Now() -> CURRENT_TIMESTAMP
	if re.match(r'(?i)^new\s*\(\s*\)$', d) or re.match(r'(?i)^now\s*\(\s*\)$', d):
		return 'CURRENT_TIMESTAMP'
	# If it's a literal, return as-is (caller will include quotes for strings)
	return d


def map_access_type_to_sqlite(type_name: str) -> str:
	if not type_name:
		return 'TEXT'
	t = type_name.lower()
	if 'int' in t or 'long' in t or 'counter' in t:
		return 'INTEGER'
	if 'byte' in t or 'single' in t or 'double' in t or 'decimal' in t or 'numeric' in t:
		return 'REAL'
	if 'bool' in t or 'yesno' in t:
		return 'INTEGER'
	if 'date' in t or 'time' in t:
		return 'TEXT'
	if 'memo' in t or 'varchar' in t or 'char' in t or 'text' in t:
		return 'TEXT'
	if 'ole' in t or 'binary' in t or 'image' in t or 'blob' in t:
		return 'BLOB'
	return 'TEXT'


def list_access_tables(cursor: Any) -> List[str]:
	# Prefer cursor.tables() if available
	tables = []
	try:
		for row in cursor.tables():
			# row.table_name, row.table_type
			if row.table_type.upper() in ('TABLE', 'VIEW'):
				name = row.table_name
				if name is None:
					continue
				# filter system tables
				if name.startswith('MSys'):
					continue
				tables.append(name)
		return tables
	except Exception:
		# Fallback: query MSysObjects
		try:
			# Filter out system tables (MSys*) and get user tables
			rows = cursor.execute("SELECT Name FROM MSysObjects WHERE Type IN (1,4,6) AND Name NOT LIKE 'MSys%'").fetchall()
			return [r[0] for r in rows]
		except Exception:
			raise


def gather_schema(access_conn: Any) -> Tuple[Dict[str, Any], List[Dict[str, str]]]:
	cur = access_conn.cursor()
	tables = list_access_tables(cur)
	schema: Dict[str, Any] = {}
	pks: Dict[str, List[str]] = defaultdict(list)
	# collect columns and pk info
	for tbl in tables:
		cols = []
		try:
			for c in cur.columns(table=tbl):
				col = {
					'name': c.column_name,
					'type': getattr(c, 'type_name', None) or getattr(c, 'type', None) or None,
					'nullable': bool(c.nullable) if hasattr(c, 'nullable') else True,
					'size': getattr(c, 'column_size', None) if hasattr(c, 'column_size') else None,
					'default': getattr(c, 'column_def', None) if hasattr(c, 'column_def') else None,
				}
				cols.append(col)
		except Exception:
			# best-effort fallback using PRAGMA-like read - we'll try a simple SELECT and use description
			try:
				rows = cur.execute(f'SELECT * FROM [{tbl}] WHERE 1=0').description
				for d in rows:
					cols.append({'name': d[0], 'type': None, 'nullable': True, 'size': None, 'default': None})
			except Exception:
				raise

		# primary keys
		try:
			for pk in cur.primaryKeys(table=tbl):
				pks[tbl].append(pk.column_name)
		except Exception:
			# some drivers don't support primaryKeys; ignore
			pass

		schema[tbl] = {'columns': cols}

	# gather foreign keys (relations)
	fks: List[Dict[str, str]] = []
	for tbl in tables:
		try:
			for fk in cur.foreignKeys(table=tbl):
				# fk has fields: pk_table_name, pk_column_name, fk_table_name, fk_column_name
				rel = {
					'fk_table': fk.fk_table_name,
					'fk_column': fk.fk_column_name,
					'pk_table': fk.pk_table_name,
					'pk_column': fk.pk_column_name,
				}
				fks.append(rel)
		except Exception:
			# ignore if unsupported
			pass

	# Some Access DBs store relationships in MSysRelationships; try that when foreignKeys unsupported
	if not fks:
		try:
			rows = cur.execute("SELECT szRelationship, szObject, szColumn, szReferencedObject, szReferencedColumn FROM MSysRelationships").fetchall()
			for r in rows:
				# r: (relname, childTable, childCol, parentTable, parentCol)
				fks.append({'fk_table': r[1], 'fk_column': r[2], 'pk_table': r[3], 'pk_column': r[4]})
		except Exception:
			# ignore
			pass

	# attach pk info
	for tbl, info in schema.items():
		info['primary_keys'] = pks.get(tbl, [])

	return schema, fks


def create_sqlite_tables(
	sqlite_conn: Optional[sqlite3.Connection],
	schema: Dict[str, Any],
	fks: List[Dict[str, str]],
	log: Optional[Dict[str, Any]] = None,
	dry_run: bool = False,
) -> Dict[str, str]:
	cur = sqlite_conn.cursor() if sqlite_conn is not None else None
	# Build mapping from original table name -> transformed table name
	table_map = {tbl: transform_name(tbl) for tbl in schema.keys()}

	# Group foreign keys by table for inclusion in CREATE TABLE
	fk_by_table = defaultdict(list)
	for fk in fks:
		orig_fk_table = fk['fk_table']
		if orig_fk_table not in schema:
			# sometimes fk uses different naming; skip if unknown
			continue
		fk_by_table[orig_fk_table].append(fk)

	for orig_tbl, info in schema.items():
		tname = table_map[orig_tbl]
		cols_sql = []
		for col in info['columns']:
			orig_col_name = col['name']
			col_name = transform_name(orig_col_name)
			col_type = map_access_type_to_sqlite(col.get('type'))
			nullable = col.get('nullable', True)
			default = transform_default(col.get('default'))

			part = f'"{col_name}" {col_type}'
			if not nullable:
				part += ' NOT NULL'
			if default is not None:
				if default.upper() == 'CURRENT_TIMESTAMP':
					part += ' DEFAULT CURRENT_TIMESTAMP'
				else:
					# quote default unless numeric or function-like
					if re.match(r'^\d+(\.\d+)?$', default):
						part += f' DEFAULT {default}'
					else:
						part += f" DEFAULT '{default.replace("'","''")}'"
				cols_sql.append(part)

		# primary key
		pk_cols = [transform_name(c) for c in info.get('primary_keys', [])]
		pk_sql = ''
		if pk_cols:
			pk_sql = f', PRIMARY KEY ({", ".join(["\"%s\"" % c for c in pk_cols])})'

		# foreign keys for this table
		fk_sql_parts = []
		for fk in fk_by_table.get(orig_tbl, []):
			fk_col = transform_name(fk['fk_column'])
			pk_tbl = table_map.get(fk['pk_table'], transform_name(fk['pk_table']))
			pk_col = transform_name(fk['pk_column'])
			fk_sql_parts.append(f'FOREIGN KEY ("{fk_col}") REFERENCES "{pk_tbl}"("{pk_col}")')

		fk_sql = ''
		if fk_sql_parts:
			fk_sql = ', ' + ', '.join(fk_sql_parts)

		# record mapping details
		mapping_cols: List[Dict[str, Any]] = []
		for col in info['columns']:
			mapping_cols.append(
				{
					'original': col['name'],
					'transformed': transform_name(col['name']),
					'type': map_access_type_to_sqlite(col.get('type')),
					'default': transform_default(col.get('default')),
				}
			)

		if log is not None:
			log.setdefault('mappings', {})[orig_tbl] = {
				'transformed_table': tname,
				'columns': mapping_cols,
				'primary_keys': [transform_name(c) for c in info.get('primary_keys', [])],
			}

		create_stmt = f'CREATE TABLE IF NOT EXISTS "{tname}" ({", ".join(cols_sql)}{pk_sql}{fk_sql})'
		if log is not None:
			log.setdefault('actions', []).append({'action': 'create_table', 'table': tname, 'sql': create_stmt})
		if not dry_run and cur is not None:
			cur.execute(create_stmt)

	if not dry_run and sqlite_conn is not None:
		sqlite_conn.commit()
	return table_map


def drop_all_sqlite_tables(sqlite_conn: Optional[sqlite3.Connection], log: Optional[Dict[str, Any]] = None, dry_run: bool = False) -> None:
	if sqlite_conn is None:
		if log is not None:
			log.setdefault('actions', []).append({'action': 'drop_all_tables', 'detail': 'No sqlite connection available'})
		return

	cur = sqlite_conn.cursor()
	cur.execute('PRAGMA foreign_keys=OFF')
	rows = cur.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()
	dropped: List[str] = []
	for r in rows:
		name = r[0]
		if name.startswith('sqlite_'):
			continue
		dropped.append(name)
		if not dry_run:
			cur.execute(f'DROP TABLE IF EXISTS "{name}"')

	if log is not None:
		log.setdefault('actions', []).append({'action': 'drop_tables', 'tables': dropped})

	if not dry_run:
		sqlite_conn.commit()


def copy_data(
	access_conn: Any,
	sqlite_conn: Optional[sqlite3.Connection],
	schema: Dict[str, Any],
	table_map: Dict[str, str],
	log: Optional[Dict[str, Any]] = None,
	dry_run: bool = False,
) -> None:
	acur = access_conn.cursor()
	scur = sqlite_conn.cursor() if sqlite_conn is not None else None
	for orig_tbl, info in schema.items():
		src = orig_tbl
		dst = table_map[orig_tbl]
		col_names = [c['name'] for c in info['columns']]
		transformed_cols = [transform_name(c) for c in col_names]

		sel_cols = ','.join([f'[{c}]' for c in col_names])
		try:
			rows = acur.execute(f'SELECT {sel_cols} FROM [{src}]').fetchall()
		except Exception as e:
			msg = f'Warning: failed to select data from {src}: {e}'
			print(msg)
			if log is not None:
				log.setdefault('warnings', []).append(msg)
			continue

		if not rows:
			if log is not None:
				log.setdefault('actions', []).append({'action': 'copy_data', 'table': dst, 'rows': 0})
			continue

		placeholders = ','.join(['?'] * len(transformed_cols))
		insert_sql = f'INSERT INTO "{dst}" ({", ".join(["\"%s\"" % c for c in transformed_cols])}) VALUES ({placeholders})'

		if log is not None:
			log.setdefault('actions', []).append({'action': 'copy_data', 'table': dst, 'rows': len(rows)})

		if not dry_run and scur is not None:
			for row in rows:
				# convert row to list and insert
				vals = list(row)
				scur.execute(insert_sql, vals)

	if not dry_run and sqlite_conn is not None:
		sqlite_conn.commit()


def recreate_indexes_and_constraints(
	access_conn: Any,
	sqlite_conn: Optional[sqlite3.Connection],
	schema: Dict[str, Any],
	table_map: Dict[str, str],
	log: Optional[Dict[str, Any]] = None,
	dry_run: bool = False,
) -> None:
	# Attempt to recreate indexes from Access if possible. This is best-effort.
	acur = access_conn.cursor()
	scur = sqlite_conn.cursor() if sqlite_conn is not None else None
	try:
		for tbl in schema.keys():
			# Some drivers support statistics(): index info
			try:
				for idx in acur.statistics(table=tbl):
					# idx has index_name, column_name, non_unique
					idx_name = getattr(idx, 'index_name', None) or getattr(idx, 'idx_name', None)
					col_name = getattr(idx, 'column_name', None) or getattr(idx, 'col_name', None)
					if not idx_name or not col_name:
						continue
					idx_name2 = transform_name(idx_name)
					tbl2 = table_map.get(tbl, transform_name(tbl))
					col2 = transform_name(col_name)
					try:
						if log is not None:
							log.setdefault('actions', []).append({'action': 'create_index', 'index': idx_name2, 'table': tbl2, 'column': col2})
						if not dry_run and scur is not None:
							scur.execute(f'CREATE INDEX IF NOT EXISTS "{idx_name2}" ON "{tbl2}"("{col2}")')
					except Exception:
						pass
			except Exception:
				# ignore per-table index creation failures
				pass
	except Exception:
		pass

	if not dry_run and sqlite_conn is not None:
		sqlite_conn.commit()


def main() -> None:
	parser = argparse.ArgumentParser(description='ETL Access .accdb -> SQLite with transformations')
	parser.add_argument('--dry-run', action='store_true', help='Do not write to SQLite; write schema mapping and action log to files')
	parser.add_argument('--out', default='db/schema_mapping.json', help='Output path for schema mapping JSON')
	parser.add_argument('--log', default='db/etl_log.json', help='Output path for full ETL action log JSON')
	args = parser.parse_args()

	print('Connecting to Access...')
	try:
		access_cnxn_str = f"Driver={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={ACCDB_PATH};"
		access_conn = pyodbc.connect(access_cnxn_str, autocommit=True)
	except Exception:
		print('Failed to connect to Access DB using ODBC. Ensure an Access ODBC/ACE driver is installed.')
		raise

	print('Gathering schema from Access...')
	schema, fks = gather_schema(access_conn)

	# prepare log
	log: Dict[str, Any] = {'generated_at': datetime.utcnow().isoformat() + 'Z', 'actions': [], 'mappings': {}, 'warnings': []}

	if args.dry_run:
		print('Dry-run: building schema mapping and logging planned actions...')
		# build mappings without touching SQLite
		table_map = create_sqlite_tables(None, schema, fks, log=log, dry_run=True)
		# simulate index recreation logging and data copy counts
		recreate_indexes_and_constraints(access_conn, None, schema, table_map, log=log, dry_run=True)
		copy_data(access_conn, None, schema, table_map, log=log, dry_run=True)

		# write mapping to --out and full log to --log
		try:
			with open(args.out, 'w', encoding='utf-8') as f:
				json.dump({'generated_at': log['generated_at'], 'mappings': log.get('mappings', {})}, f, indent=2)
			with open(args.log, 'w', encoding='utf-8') as f:
				json.dump(log, f, indent=2)
			print(f'Wrote schema mapping to {args.out} and full log to {args.log}')
		except Exception as e:
			print(f'Failed to write output files: {e}')
		access_conn.close()
		return

	# Non-dry-run: open SQLite and perform operations
	print('Opening SQLite...')
	sqlite_conn = sqlite3.connect(SQLITE_PATH)
	sqlite_conn.execute('PRAGMA foreign_keys=OFF')

	print('Dropping existing SQLite tables...')
	drop_all_sqlite_tables(sqlite_conn, log=log, dry_run=False)

	print('Creating transformed tables...')
	table_map = create_sqlite_tables(sqlite_conn, schema, fks, log=log, dry_run=False)

	print('Copying data...')
	copy_data(access_conn, sqlite_conn, schema, table_map, log=log, dry_run=False)

	print('Recreating indexes and constraints (best-effort)...')
	recreate_indexes_and_constraints(access_conn, sqlite_conn, schema, table_map, log=log, dry_run=False)

	sqlite_conn.execute('PRAGMA foreign_keys=ON')
	sqlite_conn.commit()

	# Sanity: print table row counts
	cur = sqlite_conn.cursor()
	print('\nLoad complete. Row counts:')
	for orig_tbl in schema.keys():
		t = table_map[orig_tbl]
		try:
			cnt = cur.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0]
		except Exception:
			cnt = 'ERROR'
		print(f' - {t}: {cnt}')

	# write full log
	try:
		with open(args.log, 'w', encoding='utf-8') as f:
			json.dump(log, f, indent=2)
		print(f'Wrote ETL log to {args.log}')
	except Exception as e:
		print(f'Failed to write log file: {e}')

	access_conn.close()
	sqlite_conn.close()


if __name__ == '__main__':
	main()

