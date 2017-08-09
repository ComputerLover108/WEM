import xlrd
import os
from datetime import date
import re

def test():
    dir = r'E:\public\重要文件'
    fname = r'170801葫芦岛天然气终端厂化验日报.xls'
    file = os.path.join(dir,fname)
    dataMining(file)

def dataMining(file):
    # 打开指定文件路径的excel文件
    # xlsfile = r'D:\AutoPlan\apisnew.xls'
    book = xlrd.open_workbook(file)  # 获得excel的book对象

    # 获取sheet对象，方法有2种：
    # sheet_name = book.sheet_names()[0]  # 获得指定索引的sheet名字
    sheet_name = '化验报表'
    sheet = book.sheet_by_name(sheet_name)  # 通过sheet名字来获取，当然如果你知道sheet名字了可以直接指定
    # sheet0 = book.sheet_by_index(0)  # 通过sheet索引获得sheet对象

    # 获取行数和列数：
    nrows = sheet.nrows  # 行总数
    ncols = sheet.ncols  # 列总数
    # print(file,sheet_name,nrows,ncols)
    title = r'葫芦岛天然气终端厂化验日报'
    data = dict()
    for row in range(sheet.nrows):
        for column in range(sheet.ncols):
            temp = sheet.cell(row,column).value
            if temp and sheet.cell(row,column).ctype==xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                    # print(row,column,temp)
                if temp==title:
                    ro=1
                    # 日期 = sheet.cell(row+ro,column).value
                    year, month, day, hour, minute, nearest_second = xlrd.xldate_as_tuple(sheet.cell(row+ro,column).value,book.datemode)
                    data['日期'] = date(year,month,day)
                    # print(row+ro,column,data)
                if temp == 'V-611':
                    ro = 1
                    co = 2
                    data['上午海管MEG浓度'] = sheet.cell(row + ro, column + co).value
                    ro = 3
                    data['下午海管MEG浓度'] = sheet.cell(row + ro, column + co).value
                if temp == 'V-616':
                    ro = 1
                    co = 3
                    data['乙二醇浓度'] = sheet.cell(row + ro, column + co).value
                    ro = 3
                    data['乙二醇日回收量m3'] = sheet.cell(row + ro, column + co).value
                if temp=="V-601(%)":                 
                    ro = 1
                    co = 1
                    data['上午海管来液含水'] = sheet.cell(row + ro, column + co).value
                    ro = 2
                    data['下午海管来液含水'] = sheet.cell(row + ro, column + co).value
                    ro = 4
                    data['海管来液密度'] = sheet.cell(row + ro, column).value
                if re.match("V-601.*9:00",temp):
                    co = 5
                    data['上午海管出口凝点'] = sheet.cell(row, column + co).value
                    co = 11
                    data['下午海管出口凝点'] = sheet.cell(row, column + co).value
                    co = 18
                    data['上午海管出口PH值'] = sheet.cell(row, column + co).value
                    co = 21
                    data['下午海管出口PH值'] = sheet.cell(row, column + co).value
                if temp=='轻油外输数据':
                    co = 6
                    data['轻油外输PH值'] = sheet.cell(row, column + co).value
                    co = 11
                    data['轻油外输凝点℃'] = sheet.cell(row, column + co).value
                if temp=="轻油入罐前数据":
                    co = 7
                    data['上午轻油入罐前含水'] = sheet.cell(row, column + co).value
                    co = 9
                    data['下午轻油入罐前含水'] = sheet.cell(row, column + co).value
                    co = 11
                    data['轻油入罐前PH值'] = sheet.cell(row, column + co).value
                if re.match('V-631',temp):
                    ro = 2
                    co = 4-2
                    data['V631A含水'] = sheet.cell(row + ro, column + co).value
                    data['V631A饱和蒸汽压'] = sheet.cell(row + ro + 1, column + co).value
                    data['V631A密度'] = sheet.cell(row + ro + 2, column + co).value
                    co = 6-2
                    data['V631B含水'] = sheet.cell(row + ro, column + co).value
                    data['V631B饱和蒸汽压'] = sheet.cell(row + ro + 1, column + co).value
                    data['V631B密度'] = sheet.cell(row + ro + 2, column + co).value
                    co = 8-2
                    data['V631C含水'] = sheet.cell(row + ro, column + co).value
                    data['V631C饱和蒸汽压'] = sheet.cell(row + ro + 1, column + co).value
                    data['V631C密度'] = sheet.cell(row + ro + 2, column + co).value
                if temp=="混合进罐前":
                    ro = 1
                    co = 0
                    data['轻油饱和蒸汽压'] = sheet.cell(row + ro, column + co).value
                if temp=="E-613饱和蒸汽压":
                    ro = 2
                    co = 8
                    data['轻油饱和蒸汽压'] = sheet.cell(row + ro, column + co).value
                    ro = 3
                    data['轻油稳定塔顶压力'] = sheet.cell(row + ro, column + co).value
                    ro = 5
                    data['轻油稳定塔底操作温度℃'] = sheet.cell(row + ro, column + co).value
                if temp=="V-616":
                    ro = 1
                    co = 3
                    data['乙二醇浓度'] = sheet.cell(row + ro, column + co).value
                    ro = 3
                    data['乙二醇日回收量m3'] = sheet.cell(row + ro, column + co).value
                if temp=="软化水" :
                    ro=1
                    data['锅炉软化水PH值'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉软化水总硬度'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉软化水总碱度'] = sheet.cell(row + ro, column + co).value
                if temp=="循环水" and sheet.cell(row,column-2).value=='软化水':
                    ro=1
                    data['锅炉循环水PH值'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉循环水总硬度'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉循环水总碱度'] = sheet.cell(row + ro, column + co).value
                if temp=="循环水" and column==0 :
                    # print(row,column,temp)
                    ro = 1
                    co = 2
                    if sheet.cell(row, column + co).value=="PH值":
                        data['循环水PH值'] = sheet.cell(row + ro, column + co).value
                    co = 5
                    if sheet.cell(row, column + co).value=="浊度":
                        data['循环水浊度'] = sheet.cell(row + ro, column + co).value
                    co = 9
                    if sheet.cell(row, column + co).value=="电导率":
                        data['循环水电导率'] = sheet.cell(row + ro, column + co).value
                    co = 13
                    if sheet.cell(row, column + co).value=="总碱度":
                        data['循环水总碱度'] = sheet.cell(row + ro, column + co).value
                    co = 17
                    if sheet.cell(row, column + co).value=="总硬度":
                        data['循环水总硬度'] = sheet.cell(row + ro, column + co).value
                    co = 19
                    if sheet.cell(row, column + co).value=="LSI":
                        data['循环水LSI'] = sheet.cell(row + ro, column + co).value
                    co = 21
                    if sheet.cell(row, column + co).value=="氯离子":
                        data['循环水氯离子'] = sheet.cell(row + ro, column + co).value
                    co = 24
                    if sheet.cell(row, column + co).value=="总铁":
                        data['循环水总铁'] = sheet.cell(row + ro, column + co).value
                if temp=="运行单机滑油":
                    rowLimit=row+3
                    columnLimit=column+11
                    for x in range(row,rowLimit):
                        for y in range(column,columnLimit):
                            if re.match('运动粘度',sheet.cell(x,y).value):
                                name = sheet.cell(x,y-2).value
                                data[name+'运动粘度'] = sheet.cell(x,y).value


    print(len(data),data)
    print(len(sheet.merged_cells))


if __name__ == '__main__':
    test()