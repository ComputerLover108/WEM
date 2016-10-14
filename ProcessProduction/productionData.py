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

# 获得指定日期基本生产数据,，如果没有则获得最近日期数据
def getPrductionData(date=date.today(),*filter):
    cursor = connection.cursor()
    SQL = "select 名称,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s )"
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)
    return data 

   

# 获得指定时间段生产统计数据（例如年累，月累，周累等）
def getProductionstatistics(startDate,endDate,unit=None,category=None,state=None):
    data = dict()
    cursor = connection.cursor()
    SQL = "select 名称,sum(数据) from 生产信息 where 日期 between %s and %s and 状态=%s and 单位=%s group by 名称 order by 名称;"    
    cursor.execute(SQL,[startDate,endDate,state,unite])
    data = dictfetchall(cursor)    
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

# 获得配产数据
def getDistributionData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '计划'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data

# 获得生产数据
def getProductionData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '生产'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data

# 获得接收数据
def getRecivedData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '接收'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data

# 获得外输数据
def getOutputData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '外输'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data
       
# 获得库存数据
def getInventoryData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '库存'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data

# 获得消耗数据
def getConsumptionData(date=date.today()):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s ) and 单位=%s and 状态=%s"
    unit = '方'
    state = '消耗'
    args = [date,unit,state]
    cursor.execute(SQL,args)
    data = dictfetchall(cursor)     
    return data

