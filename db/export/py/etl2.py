from mdb_parser import MDBParser

# Load the database file
db = MDBParser(file_path="db/Estimating.accdb")

# Get all tables and their data as strings
for table_name in db.tables:
   table = db.get_table(table_name)
   print(f"Table: {table_name}")
   for row in table:
       print(str(row))