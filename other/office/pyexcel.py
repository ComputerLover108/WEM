import os
import xlrd
import psycopg2

# from psycopg2 import sql
# cur.execute(
#     sql.SQL("insert into {} values (%s, %s)")
#         .format(sql.Identifier('my_table')),
#     [10, 20])
dbname = 'HLD'
user = 'operator'
password = '5302469'
host = '192.168.0.121'
port = '2012'
dsn = 'dbname=%s user=%s password=%s host=%s port=%s' % (
    dbname, user, password, host, port)

psycopg2.extensions.register_type(psycopg2.extensions.UNICODE)
conn = psycopg2.connect(dsn=dsn)
conn.set_client_encoding('UTF8')
cur = conn.cursor()
table = '通讯录'

cur.execute("drop table if exists %s;" % table)
cur.execute("create table if not exists 通讯录(id serial primary key,姓名 varchar,电话 varchar,手机 varchar,电邮 varchar,办公地点 varchar,单位 varchar,部门 varchar,岗位 varchar,IP varchar,备注 varchar);")
# cur.execute(sql.SQL("drop table if exists %%s;") % [sql.Identifier(table)])
# print(table)
# with open(fname, encoding='utf-8') as f:
#     cur.copy_from(f, table, sep='\t', null='\\N')

path = r"F:\public\temp"
fname = r"160420 辽东作业公司各现场单元通讯录更新.xls"
file = os.path.join(path, fname)
# print(file)
wb = xlrd.open_workbook(file)
sheet = wb.sheet_by_index(0)
单位 = 部门 = 岗位 = 姓名 = 电话 = 手机 = 电邮 = 办公地点 = ""
record = []
for row in range(sheet.nrows):
    if sheet.cell(row, 0).value:
        单位 = sheet.cell(row, 0).value
        # print(单位)
    if sheet.cell(row, 1).value:
        岗位 = sheet.cell(row, 1).value
    if sheet.cell(row, 2).value:
        姓名 = sheet.cell(row, 2).value
    if sheet.cell(row, 3).value:
        电话 = str(sheet.cell(row, 3).value).strip(".0")
    if sheet.cell(row, 4).value:
        电话 += '\n' + str(sheet.cell(row, 4).value).strip(".0")
    if row < 102:
        if sheet.cell(row, 5).value:
            手机 = str(sheet.cell(row, 5).value).strip(".0")
        if sheet.cell(row, 6).value:
            电邮 = sheet.cell(row, 6).value
    else:
        if sheet.cell(row, 6).value:
            手机 = str(sheet.cell(row, 6).value).strip(".0")
        if sheet.cell(row, 7).value:
            电邮 = sheet.cell(row, 7).value
    if row > 1:
        cur.execute(
            "insert into 通讯录 (单位, 岗位, 姓名, 电话, 手机, 电邮) values (%s,%s,%s,%s,%s,%s);", (单位, 岗位, 姓名, 电话, 手机, 电邮))
    # print(row, 单位, 岗位, 姓名, 电话, 手机, 电邮)

fname = "副本161024辽东作业公司陆地办公人员通讯录 (2).xls"
file = os.path.join(path, fname)
# print(file)
wb = xlrd.open_workbook(file)
sheet = wb.sheet_by_index(0)
单位 = "辽东作业公司机关"
for row in range(sheet.nrows):
    if sheet.cell(row, 1).value:
        部门 = sheet.cell(row, 1).value
    if sheet.cell(row, 2).value:
        岗位 = sheet.cell(row, 2).value
    if sheet.cell(row, 3).value:
        姓名 = sheet.cell(row, 3).value
    if sheet.cell(row, 4).value:
        电话 = str(sheet.cell(row, 4).value).strip(".0")
        # print(电话.strip(".0"))
    if sheet.cell(row, 5).value:
        手机 = str(sheet.cell(row, 5).value).strip(".0")
        # print(手机.strip(".0"))
    if sheet.cell(row, 6).value:
        电邮 = sheet.cell(row, 6).value
    if sheet.cell(row, 7).value:
        办公地点 = sheet.cell(row, 7).value
    # print(row, 单位, 部门, 岗位, 姓名, 电话, 手机, 电邮, 办公地点)
    if row > 1:
        cur.execute(
            "insert into 通讯录 (单位, 部门,岗位, 姓名, 电话, 手机, 电邮,办公地点) values (%s,%s,%s,%s,%s,%s,%s,%s);", (单位, 部门, 岗位, 姓名, 电话, 手机, 电邮, 办公地点))

conn.commit()
cur.close()
conn.close()
