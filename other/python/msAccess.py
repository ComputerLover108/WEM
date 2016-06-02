#-------------------------------------------------------------------------------
# Name:        msAccess
# Purpose:
#
# Author:      wkx
#
# Created:     23/06/2015
# Copyright:   (c) public 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------
import os
import platform
import argparse
import pyodbc
import pypyodbc
def isWindows():
    sysstr = platform.system()
    return (sysstr =="Windows")

class MSAccess:
    def __init__(self, fileName):
##        if fileName.endswith('.accdb'):
##            driver = 'Microsoft Access Driver (*.mdb, *.accdb)'
##        else:
##            driver = 'Microsoft Access Driver (*.mdb)'
##        DSN = 'DRIVER={%s};DBQ=%s;ExtendedAnsiSQL=1' % (driver, os.path.abspath(fileName))
##        self.conn=pyodbc.connect(DSN)
        if isWindows():
            self.conn=pypyodbc.win_connect_mdb(fileName)
            self.cur=self.conn.cursor()
        else :
            DSN = 'Driver=MDBTools;DBQ={fname}'.format(fname=fileName)
            self.conn = pypyodbc.connect(DSN)
            self.cur = self.conn.cursor()

    def getTables(self):
##        不收集系统表
        tables=list()
        tables=[x[2] for x in self.cur.tables().fetchall() if x[3] == 'TABLE']
        return tables

    def getFields(self,table):
        fields=[column[3] for column in self.cur.columns(table)]
        return fields

    def createFields(self,table):
        CharacterTypes=['VARCHAR','MEMO','TEXT','LONGCHAR']
        ArbitraryPrecisionNumberTypes=['NUMERIC']
        columnDef = dict()
        field_list = list()
        for column in self.cur.columns(table=table):
            columnDef['column_name']=column[3]
            columnDef['type_name']=column[5]
            columnDef['column_size']=column[6]
            columnDef['decimal_digits']=column[8]
            columnDef['num_prec_radix']=column[9]

            if column[5] == 'COUNTER' :
                columnDef['type_name'] = 'SERIAL'
            if column[5] == 'DOUBLE' :
                columnDef['type_name'] = 'REAL'
            if column[5] == 'LONGCHAR'  :
                columnDef['type_name'] = 'TEXT'
            # if column[5] == 'VARCHAR' and column[6] !=0 and column[6] !=255 :
            #     columnDef['type_name'] +='('+str(column['column_size']) +')'
            if columnDef['type_name'] in CharacterTypes and  columnDef['column_size']  != None:
                # print(columnDef['column_name'],columnDef['type_name'],columnDef['column_size'])
                columnDef['type_name'] +='('+str(column['column_size']) +')'
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


    def createTable(self):
        table_list=list()
        table_list=[x[2] for x in self.cur.tables().fetchall() if x[3] == 'TABLE']
        SQL=''
        for table in table_list:
            SQL += '\nCREATE TABLE IF NOT EXISTS  "{table}" (\n'.format(table=table)
            SQL += self.createFields(table)
            SQL +="\n);\n"
        print(SQL)
        # self.SQL += SQL
        # print(self.SQL.encode(encoding='utf-8'))
        # self.pg_cur.execute(SQL)
        # self.pg_con.commit()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-F", "--file",type=str,help="Access file")
    args = parser.parse_args()
    if args.file :
        src=args.file
        if not os.path.exists(src):
         print('Access 数据库 ('+src+')没找到!')
         exit(0)
        else:
            x=MSAccess(src)
            x.createTable()

if __name__ == '__main__':
    main()
