# -*- coding: utf-8 -*-
"""
Created on Sat Oct 24 23:41:54 2020

@author: selam
"""
#Project: Laboratory of Data Science course group project, University of Pisa,Italy
#Task: Populating a CPU fact table from a .csv file
#import necessary packages
import pyodbc 
import csv
# Create connection to the database
server = ''
db = ''
username = '' 
password = ''
conn_string = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+db+';UID='+username+';PWD='+password
conn = pyodbc.connect(conn_string)
# sql query  to insert rows to to cpu_sales table   
sql_cpuSales = '''Insert into Cpu_sales(cpu_code, time_code, geo_code, 
vendor_code, sales_usd,sales_currency)
values(?,?,?,?,?,?);'''
# function declaration 
def Insert_rows_to_CpuSales(CpuSalesIfile):
    # Instantiate cursor object
    CpuSales_cursor = conn.cursor()
    # control variable for number of rows inserted to Cpu_sales table
    cpu= 0 
    # open cpu_sales.csv file in read  mode and iterate through rows, append each row to a list, 
    # cast type of corresponding attribute value, insert the row to cpu_sales table
    with open(CpuSalesIfile, "r") as CpuSales_file:
        csv_reader = csv.DictReader(CpuSales_file)
        for row in csv_reader:
            # parse row values into list
            row_values = list(row.values())
            #cpucode_Factid
            cpucode = int(float(row_values[0]))
            timecode = int(row_values[1])
            geocode = int(row_values[2])
            vendorcode = int(row_values[3])
            salesUSD = round(float(row_values[4]),4)
            salescurrency = float(row_values[5])
            CpuSales_cursor.execute(sql_cpuSales,cpucode,timecode,geocode,
                                    vendorcode,salesUSD,salescurrency)
            cpu+=1
            # instantiate row_values list object to empty 
            row_values = []
    # print total number of records written to cpu_sales table
    print(f" Total number of cpu sales records written to the table: {cpu} ")
    conn.commit()
    conn.close()
# function call
Insert_rows_to_CpuSales("F:/LDS/LDS_2020/project_data/CPU_fact.csv") 
 