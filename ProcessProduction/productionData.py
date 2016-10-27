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

# 按生产状态获得数据
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
        data[k]=dictfetchall(cursor)
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
        data[name] = dictfetchall(cursor) 
    return data