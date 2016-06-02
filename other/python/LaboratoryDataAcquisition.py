# -*- coding: utf-8 -*-
"""
Created on Wed Oct 28 17:00:20 2015

@author: public
"""
import re
import os
import xlrd
import argparse
import psycopg2

def test(src):
    x = WaterTestData(src)
    x.run()
    for record in x.data:
        print(record)
    s="提取{0}条数据！".format(len(x.data))
    print(s)

def canOpenExcel(fileName):
    result = False
    try:
        wb = xlrd.open_workbook(fileName,formatting_info=True)
        result = True
        return result
    except xlrd.XLRDError:
        print("%s Can't open!"%fileName) 
    finally:
        wb = None
        return result 

class TestData:
    def __init__(self,src):
        self.source = src
        self.data = []
    def run(self):
        if os.path.isfile(self.source) :
            self.data.append(self.getData(self.source))
        if os.path.isdir(self.source):
            self.data = self.dataMining(self.source)
            
    def dataMining(self):
        data = []
        condition = False
        for parent,dirs,files in os.walk(pathName):
            for file in files:
                fname = os.path.join(parent,file)
                condition = canOpenExcel(fname)
                if condition :
                    temp = self.getData(fname)
                    data.append(temp)
        return data
    
    def getData(self):
        Flag = '化验报表'
        Title = '葫芦岛天然气终端厂化验日报'
        wb = xlrd.open_workbook(fileName)        
        for sh in wb.sheets():
            if sh.name == Flag :
                数据源 = fileName
                for row in range(sh.nrows):    
                    for col in range(sh.ncols):
                        temp = sh.cell(row,col).value
#                        乙二醇
                        pattern = r'乙二醇*'
                        if re.match(pattern,temp):
                            ro=1
                            co=3
                            乙二醇浓度=sh.cell(row+ro,col+3).value
                            ro=

#                        轻油
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        轻油入罐前数据
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass                        
# #                        轻油外输数据
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass                             
# #                        液化石油气
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        E-613
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        运行单机滑油
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        天然气分析
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        V-641A
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        锅炉水
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        循环水
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        凝点
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass
# #                        备注
#                          pattern= r''
#                          if re.match(pattern,temp):
#                              pass                        
        return data
        
class WaterTestData:
    def __init__(self,source):
        self.source = source
        self.data = []

    def run(self):
        if os.path.isfile(self.source) :
            self.data.append(self.getData(self.source))
        if os.path.isdir(self.source):
            self.data = self.dataMining(self.source)


    def dataMining(self,pathName):
        data = []
        condition = False
        for parent,dirs,files in os.walk(pathName):
            for file in files:
                fname = os.path.join(parent,file)
                condition = canOpenExcel(fname)
#                print(condition,fname)
                if condition :
                    temp = self.getData(fname)
#                    print(temp)
                    data.append(temp)
        return data

    def getData(self,fileName):
        Flag = '化验报表'
        Title = '葫芦岛天然气终端厂化验日报'
        Aim = '循环水'
        data = []
        wb = xlrd.open_workbook(fileName)
        for sh in wb.sheets():
    #            print(sh.name)
            if sh.name == Flag :
    #                print(sh.nrows,sh.ncols)
                数据源 = fileName
                for row in range(sh.nrows):
                    for col in range(sh.ncols):
                        value = sh.cell(row,col).value
                        if value == Title:
                            ro = 1
                            日期 =  xlrd.xldate.xldate_as_datetime(sh.cell(row+ro,col).value,0)
                        if value == Aim and  col==0:
                            名称 = sh.cell(row,col).value
    #                            print(row,col,value)
                            ro = 1
                            co = 2
                            PH值 = sh.cell(row+ro,col+co).value
                            co = 5
                            浊度 = sh.cell(row+ro,col+co).value
                            co = 9
                            电导率 = sh.cell(row+ro,col+co).value
                            co = 13
                            总碱度 = sh.cell(row+ro,col+co).value
                            co = 17
                            总硬度 = sh.cell(row+ro,col+co).value
                            co = 19
                            LSI = sh.cell(row+ro,col+co).value
                            co = 21
                            氯离子 = sh.cell(row+ro,col+co).value
                            co = 24
                            总铁 = sh.cell(row+ro,col+co).value
                data =[日期,名称,PH值,浊度,电导率,总碱度,总硬度,LSI,氯离子,总铁,数据源]
        return data

def main():
    parser = argparse.ArgumentParser(description='从葫芦岛终端化验日报中提取数据[excel 文件或所在目录]')
    parser.add_argument(dest="src", type=str)
    parser.add_argument("-H","--host",type=str,default='127.0.0.1',help="default host is 127.0.0.1")
    parser.add_argument("-P","--port",type=str,default='2012',help="default port is 2012")
    parser.add_argument("-U","--user",type=str,default='operator',help="default user is postgres")
    parser.add_argument("-W","--password",type=str,default='5302469',help="default password is empty!")
    parser.add_argument("-D","--database",type=str,default='HLD',help="default database is postgres")    
    args = parser.parse_args()
    if args.src :
        print(args.src)
        test(args.src)

if __name__ == '__main__':
    main()
