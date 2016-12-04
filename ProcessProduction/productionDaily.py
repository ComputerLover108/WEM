# 获得日报数据步骤
# 1.获得基础数据 getBaseData() [上游，海管，天然气，轻油，轻烃，化学药剂，水，电，备注，数据库]
# 2.获得相关数据 getRelatedData()
# 3.获得推导数据 getDerivedData()

from django.db import connection
from datetime import date,timedelta
import time
from math import pi
from .models import 生产信息
import re
import logging
logger = logging.getLogger(__name__)

def getProductionDailyData(date):
    data = dict()
    data['日期'] = date
    getBaseData(data,date)
    getDerivedData(data,date) 
    return data

def getBaseData(data,date): 
    getDistributionData(data,date)
    getUpstreamData(data,date)
    getSeaPipeData(data,date)
    getGasData(data,date)
    getOilData(data,date)
    getHydrocarbonData(data,date)
    getChemicalsData(data,date)
    getWaterData(data,date)
    getPowerData(data,date)
    getRemark(data,date)

# 配产
def getDistributionData(data,date):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据,类别,状态,备注 from 生产信息 where 日期=%s and 状态=%s"
    state = '计划'
    args = [date,state]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    for row in rows :
        key = row[1] + row[2]
        value = row[3]
        data[key] = value

# 海管
def getSeaPipeData(data,date):
    pass

# 上游
def getUpstreamData(data,date):
    category = '上游'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records:
        if re.match('JZ20-2凝析油',record.名称) :
            name = record.名称.replace('-','')
            if record.单位 == '方' :
                name = name+'数据'
                context[name] = record.数据
            if re.match('吨/立方米',record.单位) :
                name = name
#                print(name,record.数据)
                context[name] = record.数据

# 天然气
def getGasData(data,date):
    names = (
        '稳定区',
        '入厂计量',
        # '锦天化',
        '精细化工',
        '污水处理厂',
        '新奥燃气',
        '自用气'
    )
    category = '天然气'    
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据,类别,状态,备注 from 生产信息 where 日期=%s  and 名称 in %s and 类别=%s"
    args = [date,names,category]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    for row in rows :
        key = row[1] + row[2]
        value = row[3]
        data[key] = value    

# 轻油
def getOilData(data,date):
    pass

# 轻烃
def getHydrocarbonData(data,date):
    pass

# 化学药剂
def getChemicalsData(data,date):
    pass

# 水
def getWaterData(data,date):
    pass

# 电
def getPowerData(data,date):
    pass

# 备注
def getRemark(data,date):
    pass

# 相关数据
def getRelatedData(data,date):
    pass

# 推导数据
def getDerivedData(data,date):
    getRelatedData(data,date)

