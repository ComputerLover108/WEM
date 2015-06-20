#-------------------------------------------------------------------------------
# Name:        模块1
# Purpose:
#
# Author:      wkx
#
# Created:     01/06/2015
# Copyright:   (c) wkx 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import argparse
import pypyodbc
import os
import csv
import platform
import psycopg2
from datetime import datetime, date, time

class AccessToPostreSQL:
    def __init__(self, mdbFile, pg_con_string):
        if isWindows():
            self.ac_con=pypyodbc.win_connect_mdb(mdbFile)
            self.ac_cur = self.ac_con.cursor()
        self.pg_con = psycopg2.connect(pg_con_string)
        self.pg_cur = self.pg_con.cursor()
        self.SQL=""

    def createTable(self):
        table_list=list()
        table_list=[x[2] for x in self.ac_cur.tables().fetchall() if x[3] == 'TABLE']
        for table in table_list:
            self.SQL += "\nCREATE TABLE " + table +" IF NOT EXISTS"+ "\n("
            self.SQL += self.createFields(table)
            self.SQL +="\n);"

        print(self.SQL)

    def createFields(self,table):
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
##        for column in self.access_cur.columns(table=table):
##            if column.type_name in postgresql_fields:
##                field_list += ['"' + column.column_name + '"' +
##                               " " + postgresql_fields[column.type_name], ]
##            elif column.type_name == "DECIMAL":
##                field_list += ['"' + column.column_name + '"' +
##                               " numeric(" + str(column.column_size) + "," +
##                               str(column.decimal_digits) + ")", ]
##            else:
##                print( "column " + table + "." + column.column_name +
##                " has uncatered for type: " + column.type_name)

        return ",\n ".join(field_list)

    def mdbExport(self):
        pass

    def pgImport(self):
        pass

def isWindows():
    sysstr = platform.system()
    return (sysstr =="Windows")

def createSQL(fileName):
    if isWindows() :
        connection=pypyodbc.win_connect_mdb(fileName)
        cur = connection.cursor()
        Tables = [x[2] for x in cur.tables().fetchall() if x[3] == 'TABLE']
        for Table in Tables:
            s=createTable(Table,fileName)
##        cur.commit()
        connection.close()
    else :
        pass;
    print(SQL)
    return(SQL+s+"\n")

def createTable(Table,fileName):
    field=createField(Table,fileName)
    s="""
    CREATE IF NOT EXISTS %s
    (
        %s,
    );
    """ %(Table,field)
    print(s)
    return(SQL+s+"\n")


def createField(Table,fileName):
    connection=pypyodbc.win_connect_mdb(fileName)
    cur = connection.cursor()
    for Column in cur.columns(table=Table):
        if Column[5]=='VARCHAR' :
            s="""
                "%s" %s(%s),
            """ %(Column[3],Column[5],Column[6])
        else:
            s="""
                "%s" %s,
                """ %(Column[3],Column[5])
##        print(s)
    connection.close()
    print(s)
    return(SQL+s+",\n")


def accessToCSV():
    pass;

def csvToPostgreSQL():
    pass;


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
##            access_con_string='DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=%s;' %(src)
            print(src,pg_con_string)
            x=AccessToPostreSQL(src,pg_con_string)
            x.createTable()


if __name__ == '__main__':
    main()
