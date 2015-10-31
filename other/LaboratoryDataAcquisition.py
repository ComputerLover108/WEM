# -*- coding: utf-8 -*-
"""
Created on Wed Oct 28 17:00:20 2015

@author: public
"""
import os
import xlrd
#import psycopg2

def test():
    fileName = r'E:\public\test\2015年化验报表\10月\151001葫芦岛天然气终端厂化验日报.xls'
    pathName = r'E:\public\test\2015年化验报表'
#    fileName = r'D:\public\HLD\工艺\2015年化验报表\10月\151001葫芦岛天然气终端厂化验日报.xls'
#    pathName= r'D:\public\HLD\工艺\2015年化验报表'
    x = WaterTestData(pathName)
    x.run()
#    print(x.data)
    print(len(x.data))

def canOpenExcel(fileName):
    result = False
    try:
        wb = xlrd.open_workbook(fileName)
        result = True
        return result
    except xlrd.XLRDError:
        print("%s Can't open!"%fileName) 
    finally:
        wb = None
        return result        

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
    test()

if __name__ == '__main__':
    main()
