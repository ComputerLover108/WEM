import os
import json
import pyodbc
import psycopg2
import time
import sys

# Refer to https://code.google.com/p/pyodbc/wiki/Cursor for information on
# cursor.tables and cursor.columns field names
import argparse
import pypyodbc
import pyodbc
import psycopg2

class Converter:

    def __init__(self, access_con_string, pg_con_string, print_SQL):

        self.access_cur = pyodbc.connect(access_con_string).cursor()
        self.access_cur = pypyodbc.win_connect_mdb(access_con_string).cursor()
##        self.pg_con = psycopg2.connect(pg_con_string)
        self.pg_cur = self.pg_con.cursor()

        self.print_SQL = print_SQL

        self.schema_name = self.get_access_db_name()

    def get_access_db_name(self):

        # The full path of the database is stored in the table information
        # We can parse it to get the file name (to use as scheme_name)
        for table in self.access_cur.tables():
            return os.path.splitext(os.path.basename(table.table_cat))[0]

    def create_schema(self):

        SQL = """
        CREATE SCHEMA "{schema_name}"
        """.format(schema_name=self.schema_name)

        if self.print_SQL:
            print(SQL)

        self.pg_cur.execute(SQL)
        self.pg_con.commit()

    def create_tables(self):

        # Generate list of tables in schema
        table_list = list()
        for table in self.access_cur.tables():
            if table.table_type == "TABLE":
                table_list += [table.table_name, ]

        for table in table_list:
            SQL = """
            CREATE TABLE "{schema}"."{table}"
            (
            """.format(schema=self.schema_name, table=table)

            SQL += self.create_fields(table)

            SQL += """
            ) """

            if self.print_SQL:
                print(SQL)

            self.pg_cur.execute(SQL)
            self.pg_con.commit()

    def create_fields(self, table):

        postgresql_fields = {
            'COUNTER': 'serial',  # autoincrement
            'VARCHAR': 'text',  # text
            'LONGCHAR': 'text',  # memo
            'BYTE': 'integer',  # byte
            'SMALLINT': 'integer',  # integer
            'INTEGER': 'bigint',  # long integer
            'REAL': 'real',  # single
            'DOUBLE': 'double precision',  # double
            'DATETIME': 'timestamp',  # date/time
            'CURRENCY': 'money',  # currency
            'BIT':  'boolean',  # yes/no
        }

        SQL = ""
        field_list = list()
        for column in self.access_cur.columns(table=table):
            if column.type_name in postgresql_fields:
                field_list += ['"' + column.column_name + '"' +
                               " " + postgresql_fields[column.type_name], ]
            elif column.type_name == "DECIMAL":
                field_list += ['"' + column.column_name + '"' +
                               " numeric(" + str(column.column_size) + "," +
                               str(column.decimal_digits) + ")", ]
            else:
                print( "column " + table + "." + column.column_name +
                " has uncatered for type: " + column.type_name)

        return ",\n ".join(field_list)

    def insert_data(self):

        # Generate list of tables in schema
        table_list = list()
        for table in self.access_cur.tables():
            if table.table_type == "TABLE":
                table_list += [table.table_name, ]

        for table in table_list:
            data = self.get_access_data(table)

            # check that data exists
            if data != []:
                # Create format string (eg (%s,%s,%s)
                # the same size as the number of fields)
                format_string = "(" + ",".join(["%s", ]*len(data[0])) + ")\n"

                # pre-bind the arguments before executing - for speed
                args_string = ','.join(self.pg_cur.mogrify(format_string, x)
                                       for x in data)

                SQL = """INSERT INTO "{schema_name}"."{table_name}"
                VALUES {value_list}""".format(schema_name=self.schema_name,
                                              table_name=table,
                                              value_list=args_string)

                if self.print_SQL:
                    print(SQL)

                self.pg_cur.execute(SQL)

                self.pg_con.commit()

    def get_access_data(self, table):

        SQL = """SELECT *
        FROM {table_name}""".format(table_name=table)

        self.access_cur.execute(SQL)

        rows = self.access_cur.fetchall()

        data = list()
        for row in rows:
            data += [row, ]

        return data

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-F", "--file",type=str,help="Access file")
    parser.add_argument("-H","--host",type=str,default='127.0.0.1',help="default host is 127.0.0.1")
    parser.add_argument("-P","--port",type=str,default='2012',help="default port is 2012")
    parser.add_argument("-U","--user",type=str,default='operator',help="default user is postgres")
    parser.add_argument("-W","--password",type=str,default='5302469',help="default password is empty!")
    parser.add_argument("-D","--database",type=str,default='HLD',help="default database is postgres")
    args = parser.parse_args()
    if args.file :
        src=args.file
        if not os.path.exists(src):
         print('Access 数据库 ('+src+')没找到!')
         exit(0)
        else:
            host=args.host
            port=args.port
            user=args.user
            password=args.password
            dbname=args.database
            pg_con_string='dbname=%s user=%s password=%s host=%s port=%s' %(dbname,user,password,host,port)
            print_SQL=""
##            path=os.path.normcase(src)
##            print(path)
            access_con_string='DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=%s;' %(src)
            print(access_con_string,pg_con_string)
            Converter(access_con_string,pg_con_string,print_SQL)

if __name__ == '__main__':
    main()