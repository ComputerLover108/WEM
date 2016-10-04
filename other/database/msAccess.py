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

    def getTables(self):
##        不收集系统表
        tables=list()
        tables=[x[2] for x in self.cur.tables().fetchall() if x[3] == 'TABLE']
        return tables

    def getFields(self,table):
        fields=[column[3] for column in self.cur.columns(table)]
##        for column in self.cur.columns(table):
##            print(column)
        return fields

    def exportTableDefine(self,table):
##        fields=self.getFields(table)
        CharacterTypes=['VARCHAR','MEMO','TEXT','LONGCHAR']
        ArbitraryPrecisionNumberTypes=['NUMERIC']
        SQL = "\nCREATE TABLE IF NOT EXISTS {table}(\n".format(table=table)
        for column in self.cur.columns(table):
            if column[5] in CharacterTypes:
                SQL += '\t%s\t%s(%d%)'%(column[3],column[5],column[6])
                continue
            if column[5] in ArbitraryPrecisionNumberTypes:
                SQL += '\t%s\t%s(%d,%d)'%(column[3],column[5],column[6],column[7])
                continue
            s='\t%s\t%s'%(column[3],column[5])
        SQL += "\n);\n"
        print(SQL)

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
            for table in x.getTables():
#               x.getFields(table)
               x.exportTableDefine(table)

if __name__ == '__main__':
    main()
