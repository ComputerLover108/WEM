import os
import xlrd
path=r"E:\public\test"
fname=r"160420 辽东作业公司各现场单元通讯录更新.xls"
file=os.path.join(path,fname)
# print(file)
wb = xlrd.open_workbook(file)
sheet = wb.sheet_by_index(0)
单位=部门=岗位=姓名=电话=手机=电邮=办公地点=""
for row in range(sheet.nrows):
    if row>1:
        if sheet.cell(row,0).value :
            单位 = sheet.cell(row,0).value
            # print(单位)
        if sheet.cell(row,1).value:
            岗位 = sheet.cell(row,1).value
        if sheet.cell(row,2).value:
            姓名 = sheet.cell(row,2).value
        if sheet.cell(row, 3).value:
            电话 = str(sheet.cell(row,3).value)
        if sheet.cell(row, 4).value:
            电话 += '\n'+str(sheet.cell(row,4).value)
        if row<102:
            if sheet.cell(row, 5).value:
                手机 = str(sheet.cell(row,5).value)
            if sheet.cell(row, 6).value:
                电邮 = sheet.cell(row,6).value
        else:
            if sheet.cell(row, 6).value:
                手机 = str(sheet.cell(row,6).value)
            if sheet.cell(row, 7).value:
                电邮 = sheet.cell(row,7).value
        print(row,单位,岗位,姓名,电话,手机,电邮)

fname="副本161024辽东作业公司陆地办公人员通讯录 (2).xls"
file=os.path.join(path,fname)
# print(file)
wb = xlrd.open_workbook(file)
sheet = wb.sheet_by_index(0)
单位="辽东作业公司机关"
for row in range(sheet.nrows):
    if row>1 :
        if sheet.cell(row,1).value:
            部门 = sheet.cell(row,1).value
        if sheet.cell(row,2).value:
            岗位 = sheet.cell(row,2).value
        if sheet.cell(row,3).value:
            姓名 = sheet.cell(row,3).value
        if sheet.cell(row, 4).value:
            电话 = str(sheet.cell(row,4).value)
        if sheet.cell(row, 5).value:
            手机 = str(sheet.cell(row,5).value)
        if sheet.cell(row, 6).value:
            电邮 = sheet.cell(row,6).value
        if sheet.cell(row, 7).value:
            办公地点 = sheet.cell(row,7).value
        print(row, 单位,部门,岗位, 姓名, 电话, 手机, 电邮,办公地点)