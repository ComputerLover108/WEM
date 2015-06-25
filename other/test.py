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
#import tempfile
            
pathName='temp'
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
        self.SQL="SET client_encoding = 'UTF8';\n"

    def getTables(self):
        tables=list()
        tables=[x[2] for x in self.ac_cur.tables().fetchall() if x[3] == 'TABLE']
        return tables

    def getFields(self,table):
        fields=list()
        for column in self.ac_cur.columns(table=table):
            fields += [column[3],]
##        print(table,fields)
#        print(self.ac_cur.description)
        return fields

    def createTable(self):
        table_list=list()
        table_list=[x[2] for x in self.ac_cur.tables().fetchall() if x[3] == 'TABLE']
        SQL=''
        for table in table_list:
            SQL += '\nCREATE TABLE IF NOT EXISTS  "{table}" (\n'.format(table=table)
            SQL += self.createFields(table)
            SQL +="\n);\n"
##            print(self.ac_cur.primaryKeys().fetchall())
#        print('createTable():'+SQL)
        self.SQL += SQL
        # self.pg_cur.execute(SQL)
        # self.pg_con.commit()

    def createFields(self,table):
        CharacterTypes=['VARCHAR','MEMO','TEXT','LONGCHAR']
        ArbitraryPrecisionNumberTypes=['NUMERIC']
#        SQL = ""
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
        self.createTable()
        csv.register_dialect("pgSQL",lineterminator='\n',delimiter='\t',quoting=csv.QUOTE_MINIMAL)
##        print(table,csv.list_dialects())
        table_list=list()
        table_list=[x[2] for x in self.ac_cur.tables().fetchall() if x[3] == 'TABLE']
        for table in table_list:
            SQL = """SELECT * FROM {table_name}""".format(table_name=table)
##            print(SQL)
            SQL_head='\nCOPY  "{table_name}"  FROM stdin ;\n' .format(table_name=table)
            SQL_tail='\\.\n'
            self.ac_cur.execute(SQL)
            rows = self.ac_cur.fetchall()
            # outfile=os.path.join(pathName,table) + '.csv'
            outfile=table+'.csv'
            with open(outfile,'w+',encoding='utf-8') as fp:
                csvfile = csv.writer(fp,'pgSQL')
                for row in rows:
                    line=[]
                    for col in row:
                        if col == None:
                            col='\\N'
                            line.append(col)
                            continue
                        # if isinstance(col,str) :
                        #     col=col.replace('\\','\\\\')
                        #     line.append(col)
                        #     continue
                        line.append(col)
                    csvfile.writerow(line)
            with open(outfile,'rU',encoding='utf-8') as f:
                SQL_content=f.read()
                # SQL_content.strip('\r\n')

            self.SQL+=SQL_head+SQL_content+SQL_tail
            os.remove(outfile)

        #         table='"'+table+'"'
        #         self.pg_cur.copy_from(fp, table, sep='\t', null='\\N', )
        # self.pg_con.commit()

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

            # if not os.path.exists(pathName):
            #     os.mkdir(pathName)

            x=AccessToPostreSQL(src,pg_con_string)
            x.run()

            # if not os.listdir(pathName):
            #     os.rmdir(pathName)

            fname='AccessToPostgreSQL.sql'
            with open(fname,'w',encoding='utf-8',newline='\n') as f:
                f.write(x.SQL)

if __name__ == '__main__':
    main()
