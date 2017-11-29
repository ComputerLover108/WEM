# 获得日报数据步骤
# 1.获得基础数据 getBaseData() [上游，海管，天然气，轻油，轻烃，化学药剂，水，电，备注，数据库]
# 2.获得相关数据 getRelatedData()
# 3.获得推导数据 getDerivedData()

from django.db import connection
from datetime import date,datetime,timedelta
from .loadingDaily import *
import time
from math import pi
import re
import logging

logger = logging.getLogger('django')

def isMonthHead(sd):
    x = datetime.strptime(sd,"%Y-%m-%d")
    if x.day==1 :
        return True
    else:
        return False

def isYearHead(sd):
    x = datetime.strptime(sd,"%Y-%m-%d")
    if x.month==1 and x.day==1 :
        return True
    else:
        return False

def getProductionDailyData(sd):
    table = '生产信息'
    data = dict()
    data['日期'] = sd
    getBaseData(data,sd)
    if getDerivedData(data,sd):
        dataFinish(data)     
    return data
# 数据整理,除了轻油装车桶之外[保留4位小数]，其他保留2位小数
def dataFinish(data):
    names = (
        '稳定区',
        '入厂计量',
        '锦天化',
        '精细化工CNG',
        '精细化工',
        '污水处理厂',
        '新奥燃气',
        '自用气',
        'JZ202体系接收',
        'JZ251S体系接收',
        'JZ202体系外输',
        'JZ251S体系外输',
        '总产气量',
        '总外输气量',   
    )
    name1 = [x+'方' for x in names]
    nameM = ['月累'+x for x in name1]
    nameY = ['年累'+x for x in name1]
    nameC = name1 + nameM + nameY
    for k,v in data.items() :
        if isinstance(v,float):
            if k=='轻油装车桶':
                data[k] = round(v,4)
            else:
                if k in nameC or re.search('配产|需日产',k):
                    data[k] = round(v/pow(10,4),4)
                else:
                    data[k] = round(v,4)
    if '精细化工CNG方' not in data:
        data['精细化工CNG'+'方'] = '/'    
        data['月累'+'精细化工CNG'+'方'] = '/'
        data['年累'+'精细化工CNG'+'方'] = '/'
    sd = data['日期']
    for name in names:
        x = name+'方'
        y = '月累' + x
        z = '年累' + x
        data[y]= data[x] if isMonthHead(sd) else data[y] 
        data[z] = data[x] if isYearHead(sd) else data[z]



# 获得基本日报数据[原始数据]
def getBaseData(data,sd):
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据,类别,状态,备注,月累,年累,数据源 from 生产信息 where 日期=%s "
    args = [sd]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    data['日期'] = sd
    getDistributionData(data,sd,rows)
    getUpstreamData(data,sd,rows)
    getSeaPipeData(data,sd,rows)
    getGasData(data,sd,rows)
    getOilData(data,sd,rows)
    getHydrocarbonData(data,sd,rows)
    getChemicalsData(data,sd,rows)
    getWaterData(data,sd,rows)
    getPowerData(data,sd,rows)
    getRemark(data,sd,rows)   

# 配产
def getDistributionData(data,sd,rows):
    state = '计划'
    for row in rows :
        if row[5] == state :
            data[row[1]+row[2]] = row[3]

# 海管
def getSeaPipeData(data,sd,rows):
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
            data[key] = data[key]
    names = [
        '海管进口压力兆帕',
        '海管出口压力兆帕',
        '海管进口温度摄氏度',
        '海管出口温度摄氏度'
    ]
    for name in names:
        if name not in data:
            data[name] = '-'
    data['海管进出口压力兆帕'] = '{0}/{1}'.format(data['海管进口压力兆帕'],data['海管出口压力兆帕'])
    data['海管进出口温度摄氏度'] = '{0}/{1}'.format(data['海管进口温度摄氏度'],data['海管出口温度摄氏度'])

# 上游
def getUpstreamData(data,sd,rows):
    names = [
        'JZ20-2体系',
        'JZ20-2凝析油',
        'JZ20-2凝析油密度',
        'JZ20-2轻油',
        'JZ20-2轻油密度',        
        'JZ25-1S原油',
        'JZ25-1S原油密度']
    for row in rows:
        if row[1] in names:
            key = (row[1]+row[5]+row[2]).replace('-','').replace('/','每')
            # key=key.replace('/','每')
            data[key] = row[3]

# 天然气
def getGasData(data,sd,rows):
    names = (
        '稳定区',
        '入厂计量',
        '锦天化',
        '精细化工CNG',
        '精细化工',
        '污水处理厂',
        '新奥燃气',
        '自用气'
    )
    category = '天然气'    
    for row in rows :
        if (row[1] in names) and row[4]==category:
            key = row[1]+row[2]
            data[key] =row[3]
            # if key=='精细化工CNG方':
            #     logger.info(key)
            #     logger.info(row[3])

# 轻油
def getOilData(data,sd,rows):
    category = '轻油'
    pattern = '(V631[ABC]米)|(数据库轻油回收量方)|(轻油装车[方桶吨])'
    for row in rows :
        if row[4] == category :
            key = (row[1] + row[2]).replace('-','')
            # print(pattern,key,re.match(pattern,key))
            if re.match(pattern,key) :
                data[key] = row[3]
    
    cursor = connection.cursor()
    names = ['外输凝点','外输PH值','E-613饱和蒸汽压','轻油混合进罐前饱和蒸汽压']
    for name in names :
        SQL = "select 日期,名称,单位,数据,备注 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s and 名称=%s) and 名称=%s"
        logger.info('SQL:r%',SQL)
        args = [sd,name,name]
        cursor.execute(SQL,args)
        row = cursor.fetchone()
        if row:
            key = row[1]+row[2]
            data[key] = row[3]

    name = '轻油入罐前含水' 
    SQL = "select 日期,名称,单位,数据,备注 from 生产信息 where 日期=(select max(日期) from 生产信息 where 日期<=%s and 名称=%s) and 名称=%s"
    args = [sd,name,name]
    cursor.execute(SQL,args)
    for row in cursor.fetchall():
        key = row[4]+row[1]+row[2]
        data[key] = row[3]      
    if '上午轻油入罐前含水' not in data:
        data['上午轻油入罐前含水'] = '-'
    if '下午轻油入罐前含水' not in data:
        data['下午轻油入罐前含水'] = '-'        
    data['轻油入罐前含水'] = '{}/{}'.format(data['上午轻油入罐前含水'],data['下午轻油入罐前含水'])
    a = 'E-613饱和蒸汽压'
    b = '轻油混合进罐前饱和蒸汽压'
    if a and b :
        c = min(a,b)
    else:
        c = a if a else  b
    data['轻油饱和蒸汽压千帕'] = c

# 轻烃
def getHydrocarbonData(data,sd,rows):
    category = '丙丁烷'
    pattern = '(V64[123][AB]{0,1}米)|(数据库丙丁烷回收量方)|([丙丁]烷装车吨)|(液化气装车吨)'
    for row in rows :
        if row[4] == category :
            key = (row[1] + row[2]).replace('-','')
            # print(pattern,key,re.match(pattern,key))
            if re.match(pattern,key) :
                data[key] = row[3]

# 化学药剂
def getChemicalsData(data,sd,rows):
    category = '化学药剂'
    pattern = '甲醇消耗|乙二醇消耗|乙二醇回收|乙二醇浓度'
    for row in rows :
        if row[4] == category :
            key = row[1] + row[2]
            if re.match(pattern,key) :
                data[key] = row[3]

# 水
def getWaterData(data,sd,rows):
    pattern = '外供水方|自采水方|库存水米'
    category = '水'
    for row in rows :
        if row[4] == category :
            key = row[1] + row[2]
            # print(pattern,key,re.match(pattern,key))
            if re.match(pattern,key) :
                data[key] = row[3]    

# 电
def getPowerData(data,sd,rows):
    pattern = '(外供电|自发电)度'
    category = '电'
    for row in rows :
        if row[4] == category :
            key = row[1] + row[2]
            # print(pattern,key,re.match(pattern,key))
            if re.match(pattern,key) :
                data[key] = row[3] 

# 备注
def getRemark(data,sd,rows):
    names = ['上下游12吋海管通球','生产备注']
    for row in rows:
        if row[1] in names :
            data[row[1]] = row[3] if row[3] else '/'

# 相关数据
def getRelatedData(data,sd):
    if not getSimpleLoadingData(sd,data):
        return False     
    lastday = datetime.strptime(sd,"%Y-%m-%d") - timedelta(days=1)
    cursor = connection.cursor()
    cursor.execute("select count(*) from 生产信息 where 日期=%s",[lastday.strftime("%Y-%m-%d")])
    condition = cursor.fetchone()[0]
    if not condition :
        return False
    # 所需昨日月累，年累
    names = {
        '稳定区',
        '入厂计量',
        '锦天化',
        '精细化工',
        '精细化工CNG',
        '污水处理厂',
        '新奥燃气',
        '自用气',
        # 'JZ20-2体系',
        '轻油回收量',
        '丙丁烷回收量',
        '甲醇消耗',
        '乙二醇消耗',
        '乙二醇回收',
        '外供水',
        '自采水',
        '水消耗',
        '外供电',
        '自发电',
        '电消耗',
    }    
    unit = ''
    for name in names :
        pattern = '稳定区|入厂计量|锦天化|精细化工|精细化工CNG|污水处理厂|新奥燃气|自用气|轻油回收量|丙丁烷回收量|甲醇消耗|乙二醇消耗|乙二醇回收|外供水|自采水|水消耗'
        if re.match(pattern,name) :
            unit = '方'
        pattern = '外供电|自发电|电消耗'
        if re.match(pattern,name):
            unit = '度'
        for period in ['month','year'] :
            SQL = "select sum(数据) from 生产信息 where 日期 between date_trunc(%s,TIMESTAMP %s) and %s and 名称=%s and 单位=%s;"
            args = [period,lastday,lastday,name,unit]
            cursor.execute(SQL,args)
            row = cursor.fetchone()
            if period == 'month' :
                key = '昨月累'+name+unit
            if period == 'year' :
                key = '昨年累'+name+unit
            data[key] = row[0]
    
    # JZ202体系
    name = 'JZ20-2体系'
    unit = '方'
    for state in ['接收','外输'] :
        for period in ['month','year'] :
            SQL = "select sum(数据) from 生产信息 where 日期 between date_trunc(%s,TIMESTAMP %s) and %s and 名称=%s and 单位=%s and 状态=%s;"
            args = [period,lastday,lastday,name,unit,state]
            cursor.execute(SQL,args)
            row = cursor.fetchone()
            if period == 'month' :
                key = '昨月累'+name.replace('-','')+state+unit
            if period == 'year' :
                key = '昨年累'+name.replace('-','')+state+unit
            data[key] = row[0] 

    name = '库存水'
    cursor.execute("select 数据,单位 from 生产信息 where 日期=%s and 名称=%s and 单位='方';",[lastday,name])
    row = cursor.fetchone()
    name = '昨' + name + row[1]
    data[name] = row[0] 

    name = '轻油密度'
    cursor.execute("select 数据 from 生产信息 where 名称=%s and 日期<=%s order by 日期 desc limit 1",[name,sd])
    row = cursor.fetchone()
    data[name] = row[0]

    names = {'V-641A','V-641B','V-642','V-643A','V-643B'}
    unit = '吨/立方米'
    for name in names :
        cursor.execute("select 数据 from 生产信息 where 名称=%s and 单位=%s and 日期<=%s order by 日期 desc limit 1",[name,unit,sd])
        row = cursor.fetchone()
        name = name.replace('-','') + '密度'+unit.replace('/','每')
        data[name] = row[0] 

    cursor.execute("select sum(数据) from 生产信息 where 日期=%s and 名称 in ('V-631A','V-631B','V-631C') and 单位='吨' ;",[lastday])
    row = cursor.fetchone()
    data['昨轻油库存吨'] = row[0]
    cursor.execute("select sum(数据) from 生产信息 where 日期=%s and 名称 in ('V-641A','V-641B','V-642','V-643A','V-643B') and 单位='吨' ;",[lastday])
    row = cursor.fetchone()
    data['昨轻烃库存吨'] = row[0]
    return True 

# 推导数据
def getDerivedData(data,sd):
    dataReduction(data)
    if not getRelatedData(data,sd):
        return False
    
    data['JZ202体系外输方'] = data['锦天化方']*(data['JZ202体系接收方']/data['入厂计量方'])
    data['JZ202轻油接收方'] = data['数据库轻油回收量方'] - data['JZ202凝析油方']
    tankDiameter = 14.5
    for x in ['V631A','V631B','V631C'] :
        data[x+'方'] = (pi/4)*pow(tankDiameter,2)*data[x+'米']
        data[x+'吨'] = data['轻油密度'] * data[x+'方']
    data['轻油库存方'] = data['V631A方']  + data['V631B方'] +data['V631C方']
    data['轻油库存吨'] = data['V631A吨']  + data['V631B吨'] +data['V631C吨']   

    data['轻油回收量吨'] = data['轻油库存吨'] + data['轻油装车吨'] - data['昨轻油库存吨']
    data['轻油回收量方'] = data['轻油回收量吨'] / data['轻油密度']
    oilCoefficent = 25
    data['轻油处理量方'] =  data['轻油回收量方'] + oilCoefficent

    names = ['V-641A','V-641B','V-642','V-643A','V-643B']
    sphericalDiameter = 12.3
    for x in names :
        key = x.replace('-','') 
        data[key+'方'] = pi/3*(3*sphericalDiameter/2-data[key+'米'])*pow(data[key+'米'],2)
        data[key+'吨'] = data[key+'方'] * data[key+'密度'+'吨每立方米']
    for u in ['方','吨']:
        data['丙烷库存'+u] = data['V641A'+u] + data['V641B'+u]
        data['丁烷库存'+u] = data['V642'+u] + data['V643B'+u]
        data['液化气库存'+u] = data['V643A'+u]
    temp = [data[(i+'吨').replace('-','')] for i in names]
    data['轻烃库存'+'吨'] =  sum(temp)

    propaneDensity = min(data['V641A'+'密度'+'吨每立方米'],data['V641B'+'密度'+'吨每立方米'])
    butaneDensity = min(data['V642'+'密度'+'吨每立方米'],data['V643B'+'密度'+'吨每立方米'])
    liquefiedGasDensity = data['V643A'+'密度'+'吨每立方米']    
    lightHydrocarbonDensity = 0.54
    data['丙烷装车方'] = data['丙烷装车吨'] / propaneDensity
    data['丁烷装车方'] = data['丁烷装车吨'] / butaneDensity
    data['液化气装车方'] = data['液化气装车吨'] / liquefiedGasDensity

    data['轻烃回收吨'] = data['轻烃库存吨'] + data['丙烷装车吨'] + data['丁烷装车吨'] + data['液化气装车吨'] - data['昨轻烃库存吨']
    data['轻烃回收方'] = data['轻烃回收吨'] / lightHydrocarbonDensity
    data['丙丁烷回收量方'] = data['轻烃回收方']
    data['数据库轻烃回收量方'] = data['数据库丙丁烷回收量方']


    data['电消耗度'] = data['外供电度'] + data['自发电度']
    waterCoefficent = 1390
    data['库存水方'] = data['库存水米'] * waterCoefficent
    data['水消耗方'] = data['外供水方'] + data['自采水方'] + data['昨库存水方'] -data['库存水方']
    dt = dict()
    for pattern in ['昨月累','昨年累']:
        for key in data.keys():
            if re.match(pattern,key) :
                n1= key.replace('昨','')
                n2 = key.replace(pattern,'')
                if n2 in data and key in data:
                    dt[n1] = data[n2] + data[key]   
    for k,v in dt.items():
        data[k] = v
    names = [
        '锦天化',


        '精细化工CNG',
        '精细化工',
        '污水处理厂',
        '新奥燃气',
        '自用气'
    ] 
    gas = [ data[x+'方'] if x+'方' in data else 0 for x in names  ]
    gasM = [ data['昨月累'+x+'方'] if '昨月累'+x+'方' in data else 0 for x in names ]
    gasY = [ data['昨年累'+x+'方'] if '昨年累'+x+'方' in data else 0 for x in names  ]
    data['总产气量方'] = sum(gas)
    data['月累'+'总产气量方'] = sum(gasM)
    data['年累'+'总产气量方'] = sum(gasY)
    data['总外输气量方'] = data['总产气量方'] - data['自用气方']
    data['月累总外输气量方'] = data['月累总产气量方'] - data['月累自用气方']
    data['年累总外输气量方'] = data['年累总产气量方'] - data['年累自用气方']
    data['JZ251S体系接收方'] = data['入厂计量方'] - data['JZ202体系接收方']
    data['月累'+'JZ251S体系接收方'] = data['月累'+'入厂计量方'] - data['月累'+'JZ202体系接收方']
    data['年累'+'JZ251S体系接收方'] = data['年累'+'入厂计量方'] - data['年累'+'JZ202体系接收方']
    data['JZ251S体系外输方'] = data['锦天化方'] - data['JZ202体系外输方']
    data['月累'+'JZ251S体系外输方'] = data['月累'+'锦天化方'] - data['月累'+'JZ202体系外输方']
    data['年累'+'JZ251S体系外输方'] = data['年累'+'锦天化方'] - data['年累'+'JZ202体系外输方']

    data['月累天然气方'] = data['月累总外输气量方']
    data['年累天然气方'] = data['年累总外输气量方']    
    data['月累轻油方'] = data['月累轻油回收量方']
    data['年累轻油方'] = data['年累轻油回收量方']
    data['月累丙丁烷方'] = data['月累丙丁烷回收量方']
    data['年累丙丁烷方'] = data['年累丙丁烷回收量方']

    d1 = datetime.strptime(sd,"%Y-%m-%d")
    d = date(d1.year,d1.month,d1.day)
    去年年末 = date(d.year-1,12,31)
    今年年末 = date(d.year,12,31)
    剩余天数 = (今年年末-d ).days if (今年年末-d ).days else 1
    年时间进度比 = (d - 去年年末) / (今年年末 - 去年年末) * 100
    data['年时间进度比']    = 年时间进度比
    data['天然气年度完成率'] = data['年累天然气方'] / data['天然气年配产方'] * 100
    data['天然气月度完成率'] = data['月累天然气方'] / data['天然气月配产方'] * 100
    data['天然气需日产'] = (data['天然气年配产方']-data['年累天然气方'])/剩余天数
    data['轻油年度完成率'] = data['年累轻油方']/data['轻油年配产方'] * 100
    data['轻油月度完成率'] = data['月累轻油方']/data['轻油月配产方'] * 100
    data['轻油需日产'] = (data['轻油年配产方']-data['年累轻油方'])/剩余天数
    data['丙丁烷年度完成率'] = data['年累丙丁烷方']/data['丙丁烷年配产方'] * 100
    data['丙丁烷月度完成率'] = data['月累丙丁烷方']/data['丙丁烷月配产方'] * 100
    data['丙丁烷需日产'] = (data['丙丁烷年配产方']-data['年累丙丁烷方'])/剩余天数
    for k,v in data.items():
        logger.info('r%:r%',k,v) 
    return True

# 数据整理
def dataReduction(data):
    names = {
        '稳定区',
        '入厂计量',
        '锦天化',
        '精细化工',
        '精细化工CNG',
        '污水处理厂',
        '新奥燃气',
        '自用气',
        # 'JZ202体系',
        'JZ202凝析油',
        '轻油回收量',
        '丙丁烷回收量',
        '甲醇消耗',
        '乙二醇消耗',
        '乙二醇回收',
        '外供水',
        '自采水',
        '污水',
        'FIQ6102',
        'FIQ2043',
        '数据库丙丁烷回收量',
        '数据库轻油回收量',
    }
    kl=list(data.keys())    
    for k in kl:
        # condition = re.match('电|压力|温度|密度|[水液]位',k)
        # logger.info('r%,r%',k,condition)
        # FIQ5014单位千方
        if k == 'FIQ5014':
            name = k + '方'
            data[name] = data[k]*1000
            # logger.info('r%,data[%r]=r%',k,name,data[name])
            continue
        if k == 'JZ202体系':
            name = 'JZ202体系接收方'
            data[name] = data[k]
            continue
        if re.match('.*电$',k):
            name=k+'度'
            data[name]=data[k]
        if re.match('.*液位$',k):
            name = re.sub('液位','米',k)
            data[name]=data[k]
        if re.match('.*水池水位$',k):
            name = k + '米'
            data[name] = data[k]
        if re.match('.*压力$',k):
            name = k + '兆帕'
            data[name]=data[k]
        if re.match('.*温度$',k):
            name = k + '摄氏度'
            data[name]=data[k]
        if re.match('.*密度$',k):
            name = k + '千克/米'
            data[name]=data[k]
        if k in names:
            name = k + '方'
            data[name]=data[k]    
    
    for k in data.keys():
        logger.info('%r:%r',k,data[k])
    return False    