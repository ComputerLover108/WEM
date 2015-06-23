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
##import tempfile
from datetime import datetime, date, time

##创建一个为PostgreSQL数据库导入的csv方言
class pgSQL(csv.excel):
    lineterminator='\n'
    delimiter='\t'
    quoting=csv.QUOTE_MINIMAL

class AccessToPostreSQL:
    def __init__(self, mdbFile, pg_con_string):
        if isWindows():
            self.ac_con=pypyodbc.win_connect_mdb(mdbFile)
            self.ac_cur = self.ac_con.cursor()
        self.pg_con = psycopg2.connect(pg_con_string)
        self.pg_cur = self.pg_con.cursor()
        self.SQL=""

    def getTables(self):
        tables=list()
        tables=[x[2] for x in self.ac_cur.tables().fetchall() if x[3] == 'TABLE']
        return tables

    def getFields(self,table):
        fields=list()
        for column in self.ac_cur.columns(table=table):
            fields += [column[3],]
##        print(table,fields)
        print(self.ac_cur.description)
        return fields

    def createTable(self):
        table_list=list()
        table_list=[x[2] for x in self.ac_cur.tables().fetchall() if x[3] == 'TABLE']
        for table in table_list:
            self.SQL += "\nCREATE TABLE IF NOT EXISTS " + table + "(\n"
            self.SQL += self.createFields(table)
            self.SQL +="\n);\n"
##            print(self.ac_cur.primaryKeys().fetchall())
##        print(self.SQL)
        self.pg_cur.execute(self.SQL)
        self.pg_con.commit()

    def createFields(self,table):
        CharacterTypes=['VARCHAR','MEMO','TEXT','LONGCHAR']
        ArbitraryPrecisionNumberTypes=['NUMERIC']
        SQL = ""
        field_list = list()
        for column in self.ac_cur.columns(table=table):
            if column[5] in CharacterTypes :
                field_list += ['"' + column[3] +'"' + '\tTEXT' ,]
                continue
            if column[5] in ArbitraryPrecisionNumberTypes :
                field_list += ['"' + column[3] +'"'
                    + '\t' + column[5]
                    + '('
                    + str(column[6]) + ',' + str(column[7])
                    + ')',
                ]
                continue
            if column[5] == 'COUNTER' :
                field_list += ['"' + column[3] +'"' + '\tSERIAL' ,]
                continue
            if column[5] == 'DOUBLE' :
                field_list += ['"' + column[3] +'"' + '\tREAL' ,]
                continue
            if column[5] == 'DATETIME' :
                field_list += ['"' + column[3] +'"' + '\tTIMESTAMP' ,]
                continue
            field_list += ['"' + column[3] +'"' + '\t' + column[5],]
        return ",\n ".join(field_list)

    def run(self):
        csv.register_dialect("pgSQL")
##        print(table,csv.list_dialects())
        table_list=list()
        table_list=[x[2] for x in self.ac_cur.tables().fetchall() if x[3] == 'TABLE']
        pathName='temp'
        if not os.path.exists(pathName):
            os.mkdir(pathName)
        for table in table_list:
            SQL = """SELECT * FROM {table_name}""".format(table_name=table)
##            print(SQL)
            self.ac_cur.execute(SQL)
            rows = self.ac_cur.fetchall()
            outfile=os.path.join(pathName,table) + '.csv'
            with open(outfile,'w+',encoding='utf-8',) as fp:
                csvfile = csv.writer(fp,'unix',lineterminator='\n')
                for row in rows:
                    line=[]
                    for s in row:
                        if s == None:
                            s='\\N'
                        line.append(s)
##                    print(line)
                    csvfile.writerow(line)
##                csvfile.writerows(rows)
                self.createTable()
##                print(self.SQL)
                table='"'+table+'"'
                self.pg_cur.copy_from(fp, table, sep=',', null='\\N', )
        self.pg_con.commit()

def isWindows():
    sysstr = platform.system()
    return (sysstr =="Windows")

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
##            print(src,pg_con_string)
            x=AccessToPostreSQL(src,pg_con_string)
            t=x.getTables()
            for table in t:
               x.getFields(table)
            x.run()

if __name__ == '__main__':
    main()
