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
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据,类别,状态,备注,月累,年累,数据源 from 生产信息 where 日期=%s "
    args = [date]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()

    getDistributionData(data,date,rows)
    getUpstreamData(data,date,rows)
    getSeaPipeData(data,date,rows)
    getGasData(data,date,rows)
    getOilData(data,date,rows)
    getHydrocarbonData(data,date,rows)
    getChemicalsData(data,date,rows)
    getWaterData(data,date,rows)
    getPowerData(data,date,rows)
    getRemark(data,date,rows)

# 配产
def getDistributionData(data,date,rows):
    state = '计划'
    for row in rows :
        if row[5] == state :
            data[row[1]+row[2]] = row[3]

# 海管
def getSeaPipeData(data,date,rows):
    category = '海管'
    for row in rows :
        if row[4] == category :
            if row[6] :
                if re.search(row[6],row[1]):
                    data[row[1]+row[2]] = row[3]
                else:
                    data[row[1]+row[6]+row[2]] = row[3]
    pattern = r'海管[进出]口(压力兆帕|温度摄氏度)'
    for key in data :
        if re.match(pattern,key):
            data[key] = data[key] if data[key] else '-'
    data['海管进出口压力兆帕'] = '{0}/{1}'.format(data['海管进口压力兆帕'],data['海管出口压力兆帕'])
    data['海管进出口温度摄氏度'] = '{0}/{1}'.format(data['海管进口温度摄氏度'],data['海管出口温度摄氏度'])

# 上游
def getUpstreamData(data,date,rows):
    names = ['JZ20-2体系','JZ20-2凝析油','JZ25-1S原油']
    for row in rows:
        if row[1] in names:
            key = (row[1]+row[5]+row[2]).replace('-','')
            data[key] = row[3]

# 天然气
def getGasData(data,date,rows):
    names = (
        '稳定区',
        '入厂计量',
        # '锦天化',
        '精细化工CNG',
        '精细化工',
        '污水处理厂',
        '新奥燃气',
        '自用气'
    )
    category = '天然气'    
    for row in rows :
        if (row[1] in names) and row[4]==category:
            data[row[1]+row[2]] =row[3]    

# 轻油
def getOilData(data,date,rows):
    category = '轻油'
    for row in rows :
        if row[4] == category :
            key = (row[1] + row[2]).replace('-','')
            data[key] = row[3]

# 轻烃
def getHydrocarbonData(data,date,rows):
    pass

# 化学药剂
def getChemicalsData(data,date,rows):
    pass

# 水
def getWaterData(data,date,rows):
    pass

# 电
def getPowerData(data,date,rows):
    pass

# 备注
def getRemark(data,date,rows):
    pass

# 相关数据
def getRelatedData(data,date):
    pass

# 推导数据
def getDerivedData(data,date):
    getRelatedData(data,date)

