# write data from database to text file
# create connection to the database parameters:
#  Server name,Db name,Username,Pwd,sql statement,outputfilename 
import pyodbc
import csv
from collections import defaultdict
def from_Db_to_textfile(server,db,uname,pwd,sql_query,fname):
    conn_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+db+';UID='+uname+';PWD='+pwd
    conn = pyodbc.connect(conn_string)
    #print(conn)
    #sql_query = '''
    SInfo_cursor = conn.cursor() 
    row = SInfo_cursor.execute(sql_query)
    # open a file and write 
    with open("fname","a",newline='') as outCsv_file: 
        csv_writer = csv.writer(outCsv_file)
        csv_writer.writerow([c[0] for c in SInfo_cursor.description])
        #csv_writer.writerow("\n")
        for line in row:
            csv_writer.writerow(line)
        #csv_writer.writerow("\n")
