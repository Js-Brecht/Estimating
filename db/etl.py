from pydantic.alias_generators import to_snake
from mdb_parser import MDBParser
from typing import Any
import pandas as pd
import os
import sys
import sqlite3
import argparse

# Load the database file
SCHEMA_PATH = "db/EstimatingSchema-Sqlite.sql"
MDB_PATH = "db/Estimating.accdb"
SQL_PATH = "db/Estimating.db"
SKIP_TABLES = ["tblChangeOrderHistory", "tblChangeOrders"]

def transform_value(value: str) -> str:
    if isinstance(value, str):
        return to_snake(
            value
                .replace("Island", "Region")
                .replace("island", "region")
                .replace("Timestamp", "Created")
                .replace("COPID", "CopID")
        ).replace("address_1", "address2").replace("address_2", "address1")
    return value

def clear_database(conn: Any, schema_path: str) -> bool:
    """
    Completely clears an SQLite database, including schema and data.
    Keeps the database file but removes all tables, indexes, triggers, and views.
    """
    try:
        cursor = conn.cursor()

        # Get all object names (tables, indexes, triggers, views)
        cursor.execute("SELECT type, name FROM sqlite_master WHERE type IN ('table', 'index', 'trigger', 'view');")
        objects = cursor.fetchall()

        for obj_type, name in objects:
            # Skip SQLite's internal tables
            if name.startswith("sqlite_"):
                continue
            cursor.execute(f"DROP {obj_type.upper()} IF EXISTS \"{name}\";")
            print(f"Dropped {obj_type}: {name}")

        conn.commit()
        print("Database cleared successfully.")
        return True

    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
        return False
    except Exception as e:
        print(f"Unexpected error: {e}")
        return False

def create_schema(conn: Any, sql_file_path: str) -> bool:
    """
    Executes all SQL commands from a .sql file against the given SQLite database.
    Creates the database file if it does not exist.
    """
    # Validate file existence
    if not os.path.isfile(sql_file_path):
        print(f"Error: SQL file '{sql_file_path}' not found.")
        return False

    try:
        # Read SQL file content
        with open(sql_file_path, 'r', encoding='utf-8') as f:
            sql_script = f.read()

        # Connect to SQLite database (creates file if not exists)
        cursor = conn.cursor()

        # Execute the SQL script
        cursor.executescript(sql_script)

        # Commit changes
        conn.commit()
        print(f"Successfully executed SQL file '{sql_file_path}' on database '{SQL_PATH}'.")
        return True

    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
        return False
    except Exception as e:
        print(f"Unexpected error: {e}")
        return False

def main() -> None:
    parser = argparse.ArgumentParser(description="ETL script for estimating database")
    parser.add_argument('--reset', action='store_true', help='Clear the database')
    parser.add_argument('--schema', type=str, help='Create schema by way of SQL file from the specified path')
    parser.add_argument('--etl', action='store_true', help='Run the data transfer process')
    args = parser.parse_args()

    conn = sqlite3.connect(SQL_PATH)

    if args.reset:
        # Clear existing database
        if not clear_database(conn, SCHEMA_PATH):
            print("Failed to clear database.")
            return

    if args.schema:
        # Run schema SQL file
        if not create_schema(conn, args.schema):
            print("Failed to create schema.")
            return

    if args.etl:
        # Run full ETL process
        mdb = MDBParser(file_path=MDB_PATH)

        try:
            
            # Get all tables and their data as strings
            for table_name in mdb.tables:
                if table_name in SKIP_TABLES:
                    print(f"Skipping table: {table_name}")
                    continue
                ## Get table data
                table = mdb.get_table(table_name)

                ## Convert to DataFrame
                column_names = [str(col) for col in table.columns]
                rows = [row for row in table]
                df = pd.DataFrame(rows, columns=column_names)
            
                ## Rename columns
                rename_map = {}
                for col in df.columns:
                    replacement = transform_value(col)
                    if replacement != col:
                        rename_map[col] = replacement
            
                df.rename(columns=rename_map, inplace=True)

                ## Transform table name
                name = transform_value(table_name.replace("tbl", ""))
            
                ## Output activity
                print(f"Table: {name}")
                print(df)
                
                ## Write to SQLite
                cursor = conn.cursor()
                cursor.execute("PRAGMA foreign_keys=OFF;")

                cols = df.columns
                records = list(df.itertuples(index=False, name=None))
                insert_stmt = f"INSERT INTO {name} ({', '.join(cols)}) VALUES ({', '.join(['?' for _ in cols])})"
                cursor.executemany(insert_stmt, records)

                cursor.execute("PRAGMA foreign_keys=ON;")
                conn.commit()
                print(f"Inserted {len(records)} records into {name}.")

        except sqlite3.Error as e:
            print(f"SQLite error: {e}")

        except Exception as e:
            print(f"Unexpected error: {e}")

    conn.close()
        
if __name__ == "__main__":
    main()