# 工艺生产数据
# from django.db import connection
import psycopg2
from datetime import date,datetime,time,timedelta
import json
import re
import copy
import logging
import logging.config

log_filename = '../log/HLDT_debug.log'
logging.basicConfig(
    filename=log_filename,
    level=logging.DEBUG,
    format='[%(asctime)s] %(levelname)s [%(funcName)s: %(filename)s, %(lineno)d] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    filemode='a'
    )

connection = psycopg2.connect(dbname="HLD", user="operator",password="5302469", host="192.168.0.122", port="2012")
logger = logging.getLogger('django')
# with connection.cursor() as c:
#     c.execute(...)
    
def dictfetchall(cursor):
    columns = [col[0] for col in cursor.description]
    return [
        dict(zip(columns, row))
        for row in cursor.fetchall()
    ]

# 字典补漏,得到一个按键排序的值队列
def mend(dict,keys,filler=None):
    for x in keys :
        if x not in dict :
            # print(x)
            dict[x] = filler
    data = [dict[k] for k in keys]
    # print(data)    
    return data      

# 获得数据库内有效时间
def getAvailableTime(table,date=date.today(),upLimit=True):
    cursor = connection.cursor()
    if upLimit:
        SQL = 'SELECT max(日期) FROM {} WHERE 日期 <= %s;'.format(table)
    else :
        SQL = 'SELECT min(日期) FROM {} WHERE 日期 >= %s;'.format(table)
    args = [date]
    cursor.execute(SQL,args) 
    data = cursor.fetchone()[0]
    return data   

def dateList(startDate,endDate):
    if startDate>endDate:
        startDate,endDate=endDate,startDate
    result = [startDate+timedelta(days=i) for i in list(range((endDate-startDate).days))]
    result.append(endDate)
    return result

def dateSerial(startDate,endDate):
    result=list()
    if startDate > endDate :
        startDate,endDate = endDate,startDate
    while startDate <= endDate :
        result.append(startDate)
        startDate += timedelta(days=1)
    return result

# 获得指定日期基本生产数据,如果没有则获得最近日期数据
def getPrductionData(data,date=date.today()):
    cursor = connection.cursor()
    # SQL = "select concat(备注,名称,单位) as name ,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s )"
    SQL = "select 名称,单位,数据,状态,备注 from 生产信息 where 日期=%s"
    args = [date]
    cursor.execute(SQL,args)
    temp = cursor.fetchall()
    flags = ['JZ20-2体系','JZ25-1S体系']
    for x in temp:
        if x[0] in flags:
            name = str(x[3])+str(x[0])+str(x[1])
            # logging.debug(x)
        else:
            name = str(x[4])+str(x[0])+str(x[1])
        data[name] = x[2]
    return data  

# 获得指定时间段生产统计数据（例如年累，月累，周累等）
def getProductionstatistics(startDate,endDate):
    data = dict()
    cursor = connection.cursor()
    SQL = "select concat(名称,单位) as name,sum(数据) from 生产信息 where 日期 between %s and %s and 名称 is not null and 状态 in ('接收','生产','消耗','外输') group by 名称,单位 order by 名称,单位;"    
    # logging.debug(SQL)
    args = [startDate,endDate]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)
    logging.debug(data)    
    return data
    
# select 名称,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=current_date ) ;

# 获得海管数据
def getSeaPipeData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 类别=%s"
    category = '海管'
    args = [date,category]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor) 
    return data

# 获得上游数据
def getUpstreamData(date=date.today()):

    return data

# 按生产状态获得数据
# 获得配产数据
def getDistributionData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s and 状态=%s) and 状态=%s"
    state = '计划'
    args = [date,state,state]
    cursor.execute(SQL,args) 
    rows = cursor.fetchall()
    data = dict()
    for row in rows :
        name = row[1] + row[2]
        data[name] = row[3] 
    logger.info(data)
    return data  

def getProductionCompletion(date=date.today()):
    data = dict()
    data = getDistributionData(date)
    cursor = connection.cursor()
    names = ['总外输气量','轻油回收量','丙丁烷回收量']
    filters = ['month','year']
    unit = '方'
    SQL = "select sum(数据) from 生产信息 where 日期 between date_trunc(%s,%s) and current_date and 名称=%s and 单位=%s;"
    for name in names :
        for f in filters :
            args = [f,date,name,unit]
            cursor.execute(SQL,args)
            row = cursor.fetchone()
            if f=='month' :
                data['月累'+name+unit] = row[0]
            if f=='year' :
                data['年累'+name+unit] = row[0]
    # print(data)
    return data

# 获得生产数据
# 指定日期
def getProductionData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '生产'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    for row in rows :
        data[row[1]] = rows[2]     
    return data

# 指定时间段
def getProductionDataSet(startDate,endDate):
    data=dict()
    cursor = connection.cursor()
    state = '生产'
    SQL = "select distinct(名称) from 生产信息 where 日期 between %s and %s and 状态=%s"
    args = [startDate,endDate,state]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    names = [row[0] for row in rows if not re.match('数据库',row[0]) ]
    logging.debug(names)
    # names.remove('数据库轻油回收量')
    # names.remove('数据库丙丁烷回收量')
    # print(names)
    for name in names:
        if name=='自发电' :
            unit = '度'
        else :
            unit = '方'
        SQL = "select 日期,数据 from 生产信息 where 日期 between %s and %s and 名称=%s and 单位=%s and 状态=%s"
        args = [startDate,endDate,name,unit,state]
        cursor.execute(SQL,args)
        dv=dict()
        for row in cursor.fetchall():
            dv[row[0]] = row[1]
        data[name+unit] = dv
        logging.debug(data)
    return data    

# 获得接收数据
# 指定日期
def getRecivedData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '接收'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data
# 指定时间段
def getRecivedDataSet(startDate,endDate):
    data=dict()
    cursor = connection.cursor()
    state = '接收'
    SQL = "select distinct(名称) from 生产信息 where 日期 between %s and %s and 状态=%s"
    args = [startDate,endDate,state]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    names = {row[0] for row in rows}
    # print(names)
    for name in names:
        if name=='外供电' :
            unit = '度'
        else :
            unit ='方'
        SQL = "select 日期,数据 from 生产信息 where 日期 between %s and %s and 名称=%s and 单位=%s and 状态=%s"
        args = [startDate,endDate,name,unit,state]
        cursor.execute(SQL,args)
        dv=dict()
        for row in cursor.fetchall():
            # print(row[0],row[1])
            dv[row[0]] = row[1]
        data[name] = dv
    return data

# 获得外输数据
# 指定日期
def getOutputData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '外输'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data
# 指定时间段
def getOutputDataSet(startDate,endDate):
    data=dict()
    cursor = connection.cursor()
    unit = '方'
    state = '外输'
    SQL = "select distinct(名称) from 生产信息 where 日期 between %s and %s and 单位=%s and 状态=%s"
    args = [startDate,endDate,unit,state]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    names = {row[0] for row in rows}
    # print(names)
    for name in names:
        SQL = "select 日期,数据 from 生产信息 where 日期 between %s and %s and 名称=%s and 单位=%s and 状态=%s"
        args = [startDate,endDate,name,unit,state]
        cursor.execute(SQL,args)
        dv=dict()
        for row in cursor.fetchall():
            dv[row[0]] = row[1]
        data[name] = dv
    return data

# 获得库存数据
# 指定日期
def getInventoryData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '库存'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data
# 指定时间段
def getInventoryDataSet(startDate,endDate): 
    cursor = connection.cursor()
    data=dict()
    names=dict()
    names['轻油'] = "select 日期,sum(数据) from 生产信息 where 名称 in ('V-631A','V-631B','V-631C') and 单位='方' and 类别='轻油' and 状态='库存' and 日期 between %s and %s group by 日期 order by 日期;"
    names['丙烷'] = "select 日期,sum(数据) from 生产信息 where 备注='丙烷' and 单位='方' and 类别='丙丁烷' and 状态='库存' and 日期 between %s and %s group by 日期 order by 日期;"
    names['丁烷'] = "select 日期,sum(数据) from 生产信息 where 备注='丁烷' and 单位='方' and 类别='丙丁烷' and 状态='库存' and 日期 between %s and %s group by 日期 order by 日期;"
    names['液化气'] = "select 日期,sum(数据) from 生产信息 where 备注='液化气' and 单位='方' and 类别='丙丁烷' and 状态='库存' and 日期 between %s and %s group by 日期 order by 日期;"
    names['水'] = "select 日期,sum(数据) from 生产信息 where 单位='方' and 类别='水' and 状态='库存' and 日期 between %s and %s group by 日期 order by 日期;"
    names['乙二醇'] = "select 日期,sum(数据) from 生产信息 where 名称 in ('乙二醇库存','乙二醇死库存') and 单位='方' and 类别='化学药剂' and 状态='库存' and 日期 between %s and %s group by 日期 order by 日期;"
    args=[startDate,endDate]
    for k,v in names.items():
        cursor.execute(v,args)
        dv=dict()
        for row in cursor.fetchall():
            dv[row[0]] = row[1]
        data[k] = dv
    return data

# 获得消耗数据
# 指定日期
def getConsumptionData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '消耗'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data
# 指定时间段
def getConsumptionDataSet(startDate,endDate):
    cursor = connection.cursor()
    data=dict()
    names=['自用气','水消耗','电消耗','甲醇消耗','乙二醇消耗']
    state = '消耗'    
    for name in names:
        if name=='电消耗' :
            unit='度'
        else:
            unit='方'
        SQL = "select 日期,数据 from 生产信息 where 日期 between %s and %s and 名称=%s and 单位=%s and 状态=%s  order by 日期;"
        args = [startDate,endDate,name,unit,state]
        cursor.execute(SQL,args)
        dv=dict()
        for row in cursor.fetchall():
            dv[row[0]] = row[1]
        data[name] = dv
    return data

def test():
    table ='生产信息'
    specifiedDate = getAvailableTime(table, date.today())
    # startDate = getAvailableTime(table, date(
    #     date.today().year, 1, 1), upLimit=False)
    # endDate = getAvailableTime(table, date.today())
    data = dict()
    data['日期'] = specifiedDate
    getPrductionData(data,specifiedDate)
    logging.debug(len(data))
    for k,v in data.items():
        logging.debug("{}:{}".format(k,v))
    # logging.debug(data)
    # x = getProductionCompletion(specifiedDate) 
    # getProductionstatistics(startDate,endDate)   
    # production = getProductionDataSet(startDate, endDate)
    # received = getRecivedDataSet(startDate, endDate)
    # output = getOutputDataSet(startDate, endDate)
    # consumption = getConsumptionDataSet(startDate, endDate)
    # inventory = getInventoryDataSet(startDate, endDate)
    # dt = dateList(startDate, endDate)
    # logging.debug(x)

def main():
    test()

if __name__ == "__main__":
    main()