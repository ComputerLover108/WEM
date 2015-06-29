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
# import tempfile

##创建一个为PostgreSQL数据库导入的csv方言
class pgSQL(csv.excel):
	lineterminator='\n'
	delimiter='\t'
	quoting=csv.QUOTE_MINIMAL

class AccessToPostgreSQL:
    def __init__(self,mdbFile,host,port,user,password,database):
        if isWindows():
            self.ac_con=pypyodbc.win_connect_mdb(mdbFile)
            self.ac_cur = self.ac_con.cursor()
        self.pg_database=database
        self.pg_user=user
        self.pg_password=password
        self.pg_host=host
        self.pg_port=port
        self.pg_con = psycopg2.connect(database=database,user=user,password=password,host=host,port=port)
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
        columnDef = dict()
        field_list = list()
        for column in self.ac_cur.columns(table=table):
            columnDef['column_name']=column[3]
            columnDef['type_name']=column[5]
            columnDef['column_size']=column[6]
            columnDef['decimal_digits']=column[8]
            columnDef['num_prec_radix']=column[9]

            if column[5] == 'COUNTER' :
                columnDef['type_name'] = 'SERIAL'
            if column[5] == 'DOUBLE' :
                columnDef['type_name'] = 'REAL'
            if columnDef['type_name'] in CharacterTypes:
                columnDef['type_name'] = 'TEXT'
            if column[5] == 'DATETIME' :
                columnDef['type_name'] = 'TIMESTAMP'
            if column[5] in ArbitraryPrecisionNumberTypes :
                columnDef['type_name'] = '%s(%d,%d)'%(column[5],column[8],column[9])
            if  column[17] == 'NO' :
                # columnDef['is_nullable']='NOT NULL'
                field_list += ['"%s"\t%s\tNOT NULL'%(columnDef['column_name'],columnDef['type_name']),]
            else:
                field_list += ['"%s"\t%s'%(columnDef['column_name'],columnDef['type_name']),]

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
                        if isinstance(col,str) :
                            col=col.replace('\\','\\\\')
                            col=col.replace('\r','\\n')
                            col=col.replace('\n','\\n')
                            col=col.replace('\t','\\t')
                            line.append(col)
                            continue
                        line.append(col)
                    csvfile.writerow(line)
            with open(outfile,'rU',encoding='utf-8') as f:
                SQL_content=f.read()
                # self.pg_cur.copy_from(fp, table, sep='\t', null='\\N', )
            self.SQL+=SQL_head+SQL_content+SQL_tail
            os.remove(outfile)
        # self.pg_con.commit()
        fname='AccessToPostgreSQL.sql'
        with open(fname,'w',encoding='utf-8',newline='\n') as f:
            f.write(self.SQL)
        # command='psql -h 127.0.0.1 -p 2012 -U operator -f %s HLD' %(fname)
        command="psql -h {host} -p {port} -U {user}  -f {file} {database}".format(host=self.pg_host,port=self.pg_port,user=self.pg_user,file=fname,database=self.pg_database)
        # print(command)
        with os.popen(command) as proc:
            print(proc.read())
        os.remove(fname)


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
            database=args.database
            # pg_con_string='dbname=%s user=%s password=%s host=%s port=%s' %(database,user,password,host,port)
            # x=AccessToPostgreSQL(mdbFile=src,pg_con_string=pg_con_string)
##            access_con_string='DRIVER={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=%s;' %(src)
##            print(src,pg_con_string)


            x=AccessToPostgreSQL(mdbFile=src,host=host,port=port,user=user,password=password,database=database)
            x.run()

            # if not os.listdir(pathName):
            #     os.rmdir(pathName)



if __name__ == '__main__':
    main()
