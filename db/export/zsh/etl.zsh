#!/usr/bin/zsh
# vim: ft=zsh ts=4 sw=4 sts=4 noet ai sc si

declare me="${${(%):-%N}:a}"
declare script_dir="${me:h}"
declare MDB="db/Estimating.accdb";
declare DB="db/Estimating.db";
declare SCHEMA="db/EstimatingSchema-Sqlite.sql";
declare VALUES="db/EstimatingValues-Sqlite";

# Check for required mdb-tools
for tool in mdb-tables mdb-export; do
	if ! command -v "$tool" &> /dev/null; then
		echo "Error: $tool is not installed. Please install mdb-tools." >&2
		exit 1
	fi
done

truncate -s 0 "$DB";
sqlite3 "$DB" <"$SCHEMA";

declare tables=( "${(@f):-$(mdb-tables -1 "$MDB")}" );

for table in tblJobs; do
	declare real_table="${table#tbl}";
	echo "Importing table: \"${real_table}\"" >&2
	declare value_query="$(mdb-export -I sqlite "$MDB" "$table")";

	declare insert="$(echo "$value_query" |head -n 1 |sed -re 's/^(INSERT INTO `[^`]+`).*/\1/')";
	declare columns="$(echo "$value_query" |head -n 1 |sed -re 's/^INSERT INTO `[^`]+` (\([^)]+\)).*/\1/')";
	declare values="$(echo "$value_query" |head -n 1 |sed -re 's/^INSERT INTO `[^`]+` \([^)]+\) (VALUES .*)/\1/')";
	values+="$(echo "$value_query" |tail -n +2)";


	insert="${insert/${table}/${real_table}}";
	columns="${columns//island/region}";
	columns="${columns//Island/Region}";

	declare insert_query="${insert} ${columns} ${values}";
	declare -p insert columns values;
	
	#echo "$insert_query" >"${VALUES}-${real_table}.sql" |sqlite3 "$DB"
done 