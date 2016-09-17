# 工艺生产数据
from django.db import connection
from datetime import date,datetime,time
import json
# with connection.cursor() as c:
#     c.execute(...)
    
def dictfetchall(cursor):
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]
# 配产数据
# 获得指定日期配产数据，如果没有则获得最近日期数据
def getDistributionData(date=date.today()):
    data = dict()
    Name = {
        '天然气年配产',
        '天然气月配产',
        '轻油年配产',
        '轻油月配产',
        '丙丁烷年配产',
        '丙丁烷月配产'
    }
    unit = '方'
    state = '计划'
    cursor = connection.cursor()
    for name in Name:
        cursor.execute("select 数据 from 生产信息 where 名称=%s and 单位=%s and 状态=%s and 日期<=%s order by 日期 desc limit 1;",[name,unit,state,date])
        row = cursor.fetchone()
        data[name]=(row[0])
    return data

# 获得指定时间段配产数据
def getDistributionDataSet(beginDate,endDate=date.today()):
    data = dict()
    Name = {
        '天然气年配产',
        '天然气月配产',
        '轻油年配产',
        '轻油月配产',
        '丙丁烷年配产',
        '丙丁烷月配产'
    }
    unit = '方'
    state = '计划'
    cursor = connection.cursor()
    for name in Name:
        cursor.execute("select 数据 from 生产信息 where 名称=%s and 单位=%s and 状态=%s and 日期 between %s and %s order by 日期 ;",[name,unit,state,beginDate,endDate])
        rows = cursor.fetchall()
        data[name] = rows
        # data[name] = dictfetchall(cursor)
    return data
    # return json.dumps(data)	

def ProductionDataMonth(date=date.today()):
    data = list()
    cursor = connection.cursor()
    names = ['锦天化','轻油回收量','丙丁烷回收量']
    for name in names:
        cursor.execute("select sum(数据) from 生产信息 where 名称=%s and 单位='方' and 日期 between date_trunc('month',TIMESTAMP %s) and %s;", [name,date,date])
        row = cursor.fetchone()
        data.append(row[0])
    return data    

