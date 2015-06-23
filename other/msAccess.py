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
import pypyodbc


def isWindows():
    sysstr = platform.system()
    return (sysstr =="Windows")

class MSAccess:
    def __init__(self, fileName):
##        conn = pypyodbc.connect('Driver={Microsoft Access Driver (*.mdb)};DBQ=D:\\salesdb.mdb')
        if isWindows():
            self.conn=pypyodbc.win_connect_mdb(fileName)
        else:
            self.conn=pypyodbc.connect('Driver={Microsoft Access Driver (*.mdb)};DBQ={fname}'.format(fname=fileName))
        self.cur=self.conn.cursor()

    def getTables(self):
        tables=list()
        tables=[x[2] for x in self.cur.tables().fetchall() if x[3] == 'TABLE']
        return tables

    def getFields(self,table):
        fields=list()
##        for column in self.cur.columns(table=table):
##            fields += [column[3],]
##        print(table,fields)
##        print(self.cur.description)
        SQL='select * from {table};'.format(table=table)
        self.cur.execute(SQL)
        for column in self.cur.description:
            print(column)
        return fields

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
            t=x.getTables()
            for table in t:
               x.getFields(table)

if __name__ == '__main__':
    main()
