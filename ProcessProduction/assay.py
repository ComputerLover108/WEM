import xlrd
import os
from datetime import date
import re
import logging
# logger = logging.getLogger(__name__)
logger = logging.getLogger('django')

def test():
    dir = r'E:\public\test\2017年化验日报\8月'
    fname = r'170813葫芦岛天然气终端厂化验日报.xls'
    file = os.path.join(dir, fname)
    result=dataMining(file)

# 化验报表拆分成12个小报表
# 乙二醇 [3,1][7,11]
# 轻油 [3,14][9,25]
# 液化气 [3,26][12,30]
# 轻油饱和蒸汽压 [8,1][13,9]
# 运行单机滑油 [10,14][13,25]
# 轻烃组分 [14,1][26,26]
# 外输丙丁烷 [14,27][21,31]
# 锅炉水 [22,27][26,30]
# 循环水 [27,1][29,25]
# 原油 [30,1][30,25]
# 备注 [27,27][27,28]
# 签名 [31,1]


def split(sheet):
    nrows = sheet.nrows  # 行总数
    ncols = sheet.ncols  # 列总数
    data = dict()
    Title = '葫芦岛天然气终端厂化验日报'
    for row in range(sheet.nrows):
        for column in range(sheet.ncols):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if re.match(Title, temp):
                    beginRow = row
                    beginColumn = column
                if re.match('乙二醇浓度', temp):
                    ro = 4
                    co = 10
                    data['乙二醇'] = [row, column, row + ro, column + co]
                if re.match('V-601\(%\)',temp):
                    ro=2
                    co=1
                    data['海管来液含水'] = [row,column,row+ro,column+co]
                if '轻油' == temp:
                    ro = 6
                    co = 11
                    data['轻油'] = [row, column, row + ro, column + co]
                if re.match('液化石油气', temp):
                    ro = 9
                    co = 4
                    data['液化石油气'] = [row, column, row + ro, column + co]
                if re.match('E-613饱和蒸汽压', temp):
                    ro = 5
                    co = 8
                    data['轻油饱和蒸汽压'] = [row, column, row + ro, column + co]
                if re.match('运行单机滑油', temp):
                    ro = 5
                    co = 8
                    data['运行单机滑油'] = [row, column, row + ro, column + co]
                if re.match('锅炉水', temp):
                    ro = 4
                    co = 3
                    data['锅炉水'] = [row, column, row + ro, column + co]
                if re.match('循环水', temp):
                    ro = 2
                    co = 24
                    data['循环水'] = [row, column, row + ro, column + co]
                if re.match('凝点', temp):
                    ro = 0
                    data['原油'] = [row, column, row + ro, column + co]
                if re.match('备注', temp):
                    ro = 0
                    co = 1
                    data['备注'] = [row, column, row + ro, column + co]
    data['轻烃'] = [beginRow + 13, beginColumn, beginRow + 25, beginColumn + 25]
    data['外输丙丁烷'] = [beginRow + 13, beginColumn +
                     26, beginRow + 20, beginColumn + 30]
    # for k, v in data.items():
    #     logger.info('[%s,%s]',k,v)
    return data

# 乙二醇数据
def getGlycoData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
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
                if temp == "V-616":
                    ro = 1
                    co = 3
                    data['乙二醇浓度'] = sheet.cell(row + ro, column + co).value
                    ro = 3
                    data['乙二醇日回收量m3'] = sheet.cell(row + ro, column + co).value

# 轻油
def getLightOilData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if temp == '轻油外输数据':
                    co = 6
                    data['轻油外输PH值'] = sheet.cell(row, column + co).value
                    co = 11
                    data['轻油外输凝点℃'] = sheet.cell(row, column + co).value
                if temp == "轻油入罐前数据":
                    co = 7
                    data['上午轻油入罐前含水'] = sheet.cell(row, column + co).value
                    co = 9
                    data['下午轻油入罐前含水'] = sheet.cell(row, column + co).value
                    co = 11
                    data['轻油入罐前PH值'] = sheet.cell(row, column + co).value
                if re.match('V-631', temp):
                    ro = 2
                    co = 4 - 2
                    data['V631A含水'] = sheet.cell(row + ro, column + co).value
                    data['V631A饱和蒸汽压'] = sheet.cell(
                        row + ro + 1, column + co).value
                    data['V631A密度'] = sheet.cell(
                        row + ro + 2, column + co).value
                    co = 6 - 2
                    data['V631B含水'] = sheet.cell(row + ro, column + co).value
                    data['V631B饱和蒸汽压'] = sheet.cell(
                        row + ro + 1, column + co).value
                    data['V631B密度'] = sheet.cell(
                        row + ro + 2, column + co).value
                    co = 8 - 2
                    data['V631C含水'] = sheet.cell(row + ro, column + co).value
                    data['V631C饱和蒸汽压'] = sheet.cell(
                        row + ro + 1, column + co).value
                    data['V631C密度'] = sheet.cell(
                        row + ro + 2, column + co).value

# 轻油饱和蒸汽压
def getLightOilSaturatedVaporPressureData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if temp == "混合进罐前":
                    ro = 1
                    co = 0
                    data['轻油混合进罐前饱和蒸汽压KPa'] = sheet.cell(row + ro, column + co).value
                if temp == "E-613饱和蒸汽压":
                    ro = 2
                    co = 8
                    data['E-613饱和蒸汽压KPa'] = sheet.cell(row + ro, column + co).value
                    ro = 3
                    data['轻油稳定塔顶压力MPa'] = sheet.cell(row + ro, column + co).value
                    ro = 5
                    data['轻油稳定塔底操作温度℃'] = sheet.cell(
                        row + ro, column + co).value
    logger.info('混合进罐前:%r,E-613:%r',data['轻油混合进罐前饱和蒸汽压KPa'],data['E-613饱和蒸汽压KPa'])
    

# 滑油
def getOilData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if re.match('运动粘度', sheet.cell(row, column).value):
                    ro = 2
                    co = -4
                    name = sheet.cell(
                        row + ro, column + co).value + '运动粘度'
                    data[name] = sheet.cell(row + ro, column).value
                    ro = 3
                    name = sheet.cell(
                        row + ro, column + co).value + '运动粘度'
                    data[name] = sheet.cell(row + ro, column).value
                if re.match('机械杂质', sheet.cell(row, column).value):
                    ro = 2
                    co = -7
                    name = sheet.cell(
                        row + ro, column + co).value + '机械杂质'
                    data[name] = sheet.cell(row + ro, column).value
                    ro = 3
                    name = sheet.cell(
                        row + ro, column + co).value + '机械杂质'
                    data[name] = sheet.cell(row + ro, column).value
                if re.match('含水', sheet.cell(row, column).value):
                    ro = 2
                    co = -9
                    name = sheet.cell(row + ro, column + co).value + '含水'
                    data[name] = sheet.cell(row + ro, column).value
                    ro = 3
                    name = sheet.cell(row + ro, column + co).value + '含水'
                    data[name] = sheet.cell(row + ro, column).value

# 轻烃
def getLightHydrocarbonData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()

# 液化气
def getLiquefiedGasData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()

# 外输丙丁烷
def getOutputButaneData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()

# 锅炉水
def getBoilerWaterData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if temp == "软化水":
                    ro = 1
                    data['锅炉软化水PH值'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉软化水总硬度'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉软化水总碱度'] = sheet.cell(row + ro, column + co).value
                if temp == "循环水":
                    ro = 1
                    data['锅炉循环水PH值'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉循环水总硬度'] = sheet.cell(row + ro, column + co).value
                    ro = ro + 1
                    data['锅炉循环水总碱度'] = sheet.cell(row + ro, column + co).value

# 循环水
def getCirculatingWaterData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if temp == "循环水":
                    # print(row,column,temp)
                    ro = 1
                    co = 2
                    if sheet.cell(row, column + co).value == "PH值":
                        data['循环水PH值'] = sheet.cell(
                            row + ro, column + co).value
                    co = 5
                    if sheet.cell(row, column + co).value == "浊度":
                        data['循环水浊度'] = sheet.cell(row + ro, column + co).value
                    co = 9
                    if sheet.cell(row, column + co).value == "电导率":
                        data['循环水电导率'] = sheet.cell(
                            row + ro, column + co).value
                    co = 13
                    if sheet.cell(row, column + co).value == "总碱度":
                        data['循环水总碱度'] = sheet.cell(
                            row + ro, column + co).value
                    co = 17
                    if sheet.cell(row, column + co).value == "总硬度":
                        data['循环水总硬度'] = sheet.cell(
                            row + ro, column + co).value
                    co = 19
                    if sheet.cell(row, column + co).value == "LSI":
                        data['循环水LSI'] = sheet.cell(
                            row + ro, column + co).value
                    co = 21
                    if sheet.cell(row, column + co).value == "氯离子":
                        data['循环水氯离子'] = sheet.cell(
                            row + ro, column + co).value
                    co = 24
                    if sheet.cell(row, column + co).value == "总铁":
                        data['循环水总铁'] = sheet.cell(row + ro, column + co).value

# 原油
def getCrudeOilData(sheet, table, data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    for row in range(beginRow, endRow+1):
        for column in range(beginColumn, endColumn+1):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if re.match("V-601.*9:00", temp):
                    co = 5
                    data['上午海管出口凝点'] = sheet.cell(row, column + co).value
                    co = 11
                    data['下午海管出口凝点'] = sheet.cell(row, column + co).value
                    co = 18
                    data['上午海管出口PH值'] = sheet.cell(row, column + co).value
                    co = 21
                    data['下午海管出口PH值'] = sheet.cell(row, column + co).value

def getSeaPipeData(sheet,table,data):
    beginRow = table[0]
    endRow = table[2]
    beginColumn = table[1]
    endColumn = table[3]
    data['上午海管来液含水'] = sheet.cell(beginRow+1,beginColumn+1).value
    data['下午海管来液含水'] = sheet.cell(beginRow+2,beginColumn+1).value

def getDate(book,sheet,data):
    nrows = sheet.nrows  # 行总数
    ncols = sheet.ncols  # 列总数
    title = r'葫芦岛天然气终端厂化验日报'
    for row in range(sheet.nrows):
        for column in range(sheet.ncols):
            temp = sheet.cell(row, column).value
            if temp and sheet.cell(row, column).ctype == xlrd.XL_CELL_TEXT:
                temp = temp.strip()
                if temp == title:
                    ro = 1
                    # 日期 = sheet.cell(row+ro,column).value
                    year, month, day, hour, minute, nearest_second = xlrd.xldate_as_tuple(
                        sheet.cell(row + ro, column).value, book.datemode)
                    data['日期'] = date(year, month, day).isoformat()

def dataMining(file):
    # 打开指定文件路径的excel文件
    # xlsfile = r'D:\AutoPlan\apisnew.xls'
    book = xlrd.open_workbook(file)  # 获得excel的book对象

    # 获取sheet对象，方法有2种：
    # sheet_name = book.sheet_names()[0]  # 获得指定索引的sheet名字
    sheet_name = '化验报表'
    # 通过sheet名字来获取，当然如果你知道sheet名字了可以直接指定
    sheet = book.sheet_by_name(sheet_name)
    # sheet0 = book.sheet_by_index(0)  # 通过sheet索引获得sheet对象
    table = split(sheet)
    for k, v in table.items():
        logger.info('[%s,%s]',k,v)

    data = dict()
    getDate(book,sheet,data)
    getGlycoData(sheet, table['乙二醇'], data)
    getSeaPipeData(sheet,table['海管来液含水'],data)
    getCrudeOilData(sheet,table['原油'],data)
    getLightOilData(sheet,table['轻油'],data)
    getLightOilSaturatedVaporPressureData(sheet,table['轻油饱和蒸汽压'],data)
    # for k, v in data.items():
    #     logger.info('[%s,%s]',k,v)
    return data


if __name__ == '__main__':
    test()
