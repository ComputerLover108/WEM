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
from datetime import datetime, date, time

def isWindows():
    sysstr = platform.system()
    return (sysstr =="Windows")

def accessToCSV():
    pass;

def csvToPostgreSQL():
    pass;
    
    
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--file",type=str,help="Access file")
    args = parser.parse_args()
    if args.file :
        src=args.file
        if not os.path.exists(src):
         print('Access 数据库 ('+src+')没找到!')
         exit(0)
        else:
            if isWindows():
##                pypyodbc.win_create_mdb('D:\\database.mdb')
##                connection_string = 'Driver={Microsoft Access Driver (*.mdb)};DBQ='+src
##                connection = pypyodbc.connect(connection_string)            
                connection=pypyodbc.win_connect_mdb(src)
                connection.close()
                文件目录=os.path.dirname(src)
                文件名=os.path.basename(src)
                aim=文件名.split(".")[0]+date.today().isoformat()+"."+文件名.split(".")[1]
                print(src,aim)
                # pypyodbc.win_compact_mdb(src,aim)
            else:
                print(src)
                connection_string = 'DRIVER={MDBTools};DBQ=%s;' % (src)
                connection = pypyodbc.connect(connection_string)

if __name__ == '__main__':
    main()
