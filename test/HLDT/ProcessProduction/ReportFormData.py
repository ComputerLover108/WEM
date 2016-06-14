from django.db.models import Q
from django.db import connection
from datetime import date,timedelta
from math import pi
from .models import 生产信息
import re

# Category = ['天然气','轻油','丙丁烷','化学药剂','水','电','海管']
# State = ['计划','接收','生产','库存','消耗','外输']

# 获得字段
def getFieldValues(Table,FieldName):
    fieldValues = []
    temp = Table.objects.values(FieldName).distinct()
    # fieldValues = [ item[FieldName] for item in temp]
    for x in temp:
        if x[FieldName] :
            fieldValues.append(x[FieldName])
    # print(fieldValues)
    return fieldValues

# 获得生产信息数据
def getData(date,name,unit,category,state,remark=None):
    # print('date={},name={},unit={},category={},state={}'.format(date,name,unit,category,state))
    if remark:
        records=生产信息.objects.filter(Q(日期=date),Q(名称=name),Q(单位=unit),Q(类别=category),Q(状态=state),Q(备注=remark))
    else:
        records=生产信息.objects.filter(Q(日期=date),Q(名称=name),Q(单位=unit),Q(类别=category),Q(状态=state))
    if len(records) == 1:
        data = records[0]
        return data

def getDistributionData(context,date):
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
    Category = getFieldValues(生产信息,'类别')
    # print(Category)
    for name in Name:
        for a in Category:
            if re.match(a,name) :
                category = a
                x = getData(date,name,unit,category,state)
        context[name] = x.数据

def getSeaPipeData(context,date):
    category = '海管'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records :
#       print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(record.名称,record.单位,record.数据,record.类别,record.状态,record.月累,record.年累,record.备注))
       pattern = '海管(MEG浓度|出口PH值|出口凝点|来液含水|来液密度)'
       if re.match(pattern,record.名称) :
           name = record.名称 + record.备注 if record.备注 else record.名称
           context[name] = record.数据
#           print(name,context[name])
       pattern = '海管(进口温度|进口压力|出口温度|出口压力)'
       if re.match(pattern,record.名称) :
         name = record.名称
         context[name] = record.数据 if record.数据 else '-'
#         print(name,context[name])
#       if context['海管进口温度'] and context['海管出口温度'] :
#           context['海管进出口温度'] = '{}/{}'.format(context['海管进口温度'],context['海管出口温度'])
#       if context['海管进口压力'] and context['海管出口压力'] :
#           context['海管进出口压力'] = '{}/{}'.format(context['海管进口压力'],context['海管出口压力'])

def getUpstreamData(context,date):
    category = '上游'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records:
        if re.match('JZ20-2凝析油',record.名称) :
            # print('{}\t{}\t{}'.format(record.名称,record.单位,record.数据))
            name = record.名称.replace('-','')
            if record.单位 == '方' :
                name = name+'数据'
                context[name] = record.数据
            if re.match('吨/立方米',record.单位) :
                name = name
#                print(name,record.数据)
                context[name] = record.数据

def getGasData(context,date):
    unit = '方'
    category = '天然气'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    Name = {
        '稳定区',
        '入厂计量',
        '锦天化',
        '精细化工',
        '污水处理厂',
        '新奥燃气',
        '自用气'
    }
    for record in records:
        name = record.名称
        if name in Name :
            context[name+'数据'] = record.数据
            # context[name+'月累'] = record.月累
            # context[name+'年累'] = record.年累
    name='JZ20-2体系'
    state='接收'
    record=getData(date,name,unit,category,state)
    name = 'JZ202体系接收'
    context[name+'数据'] = record.数据
    # context[name+'月累'] = record.月累
    # context[name+'年累'] = record.年累

def getOilData(context,date):
    category = '轻油'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    x=y='-'
    for record in records:
#        print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(record.名称,record.单位,record.数据,record.类别,record.状态,record.月累,record.年累,record.备注))
        state = '库存'
        if re.match(state,record.状态) :
            name = record.名称.replace('-','')
            context[name+'_m'] = record.数据
        name = '轻油装车'
        if re.match(name,record.名称) :
#            print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(record.名称,record.单位,record.数据,record.类别,record.状态,record.月累,record.年累,record.备注))
            if record.单位 == '方' :
                context[name+'m3'] = record.数据
            if record.单位 == '桶' :
                context[name+'bbl'] = record.数据
            if record.单位 == '吨' :
                context[name+'t'] = record.数据
        pattern = '(外输凝点)|(外输PH值)|(E-613饱和蒸汽压)'
        if re.match(pattern,record.名称) :
            if record.名称 == '外输凝点' :
                context['轻油'+record.名称] = record.数据
            if record.名称 == '外输PH值' :
                context['轻油'+record.名称] = record.数据
            if record.名称 == 'E-613饱和蒸汽压' :
                context['轻油饱和蒸汽压'] = record.数据
        # if record.名称 == '轻油处理量' :
        #         context['轻油处理量m3'] = record.数据
        # if record.名称 == '轻油回收量' and record.单位 == '方' :
        #         context['轻油回收量m3'] = record.数据
        # if record.名称 == '轻油回收量' and record.单位 == '吨' :
        #         context['轻油回收量t'] = record.数据
        if record.名称 == '数据库轻油回收量' and record.单位 == '方' :
                context['数据库轻油回收量m3'] = record.数据
        pattern = '入罐前含水'
        if re.match(pattern,record.名称) :
            if record.备注 == '上午' :
                x = record.数据
#                print(record.名称,record.备注,record.数据,x,y)
            if record.备注 == '下午' :
                y = record.数据
#                print(record.名称,record.备注,record.数据,x,y)
        pattern = '数据库轻油回收量'
        if re.match(pattern,record.名称):
            name = '数据库轻油回收量m3'
            context[name] = record.数据
    context['轻油入罐前含水'] = '{}/{}'.format(x,y)
#    print('轻油入罐前含水',context['轻油入罐前含水'])


def getHydrocarbonData(context,date):
    category = '丙丁烷'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records:
#        print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(record.名称,record.单位,record.数据,record.类别,record.状态,record.月累,record.年累,record.备注))
        pattern = 'V-64([13][AB]|2)'
        if re.match(pattern,record.名称):
            unit ='米'
            if record.单位 == unit :
                name = record.名称.replace('-','')
                context[name+'_m'] = record.数据
                context[name+'介质'] = record.备注
                # print(name+'介质',record.备注)
        pattern = '(丙烷|丁烷|液化气)装车'
        if re.match(pattern,record.名称):
            unit = '吨'
            if record.单位 == unit :
                name = record.名称
                context[name+'t'] = record.数据
#                print(name,record.数据)
        pattern = '数据库丙丁烷回收量'
        if re.match(pattern,record.名称):
            name = '数据库轻烃回收量m3'
            context[name] = record.数据

def getChemicalsData(context,date):
    category = '化学药剂'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records:
#        print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(record.名称,record.单位,record.数据,record.类别,record.状态,record.月累,record.年累,record.备注))
        pattern = '甲醇消耗|乙二醇消耗|乙二醇回收'
        if re.match(pattern,record.名称):
            name = record.名称+'m3'
            context[name] = record.数据
            # context[name+'月累'] = record.月累
            # context[name+'年累'] = record.年累
        if record.名称 == '乙二醇浓度' :
            context[record.名称] = record.数据

def getWaterData(context,date):
    category = '水'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records:
#        print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(record.名称,record.单位,record.数据,record.类别,record.状态,record.月累,record.年累,record.备注))
        pattern = '外供水|自采水'
        if re.match(pattern,record.名称) :
            name = record.名称 + 'm3'
            context[name] = record.数据
            # context[name+'月累'] = record.月累
            # context[name+'年累'] = record.年累
        if record.名称 == '库存水' and record.单位 == '米' :
            name = record.名称 +'m'
            context[name] = record.数据

def getPowerData(context,date):
    category = '电'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records:
        pattern = '外供电|自发电'
        if re.match(pattern,record.名称) :
            name = record.名称 + 'KWh'
            context[name] = record.数据
            # context[name+'月累'] = record.月累
            # context[name+'年累'] = record.年累

def getRemark(context,date):
    names = ['上下游12吋海管通球','生产备注']
    records = 生产信息.objects.filter(Q(日期=date),Q(名称__in=names))
    for record in records :
        context[record.名称] = record.备注

def getRelatedData(context,d):
    lastday = d - timedelta(1)
    cursor = connection.cursor()
#    print(d,昨日)
    # 所需昨日月累，年累
    names = {
        '稳定区',
        '入厂计量',
        '锦天化',
        '精细化工',
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
        pattern = '稳定区|入厂计量|锦天化|精细化工|污水处理厂|新奥燃气|自用气|轻油回收量|丙丁烷回收量|甲醇消耗|乙二醇消耗|乙二醇回收|外供水|自采水|水消耗'
        if re.match(pattern,name) :
            unit = '方'
        pattern = '外供电|自发电|电消耗'
        if re.match(pattern,name):
            unit = '度'
        cursor.execute("select sum(数据) from 生产信息 where 日期 between date_trunc('month',TIMESTAMP %s) and %s and 名称=%s and 单位=%s;", [lastday,lastday,name,unit])
        row = cursor.fetchone()
        dataM = row[0]
        context[name+'昨月累'] = dataM
        cursor.execute("select sum(数据) from 生产信息 where 日期 between date_trunc('year',TIMESTAMP %s) and %s and 名称=%s and 单位=%s;", [lastday,lastday,name,unit])
        row = cursor.fetchone()
        dataY = row[0]
        context[name+'昨年累'] = dataY
#        print('{}\t{}\t{}\t{}'.format(lastday,name,dataM,dataY))
    # JZ202体系
    cursor.execute("select 月累,年累,状态 from 生产信息 where 日期=%s and 名称='JZ20-2体系' and 单位='方' ;",[lastday])
    rows = cursor.fetchall()
    for row in rows :
        dataM = row[0]
        dataY = row[1]
        context['JZ202体系'+row[2]+'昨月累'] = dataM
        context['JZ202体系'+row[2]+'昨年累'] = dataY
    name = '库存水'
    cursor.execute("select 数据 from 生产信息 where 日期=%s and 名称=%s and 单位='方';",[lastday,name])
    row = cursor.fetchone()
    data = row[0]
    name = '昨' + name + 'm3'
    context[name] = data

    name = '轻油密度'
    cursor.execute("select 数据 from 生产信息 where 名称=%s and 日期<=%s order by 日期 desc limit 1",[name,d])
    row = cursor.fetchone()
    data = row[0]
    context[name] = data

    names = {'V-641A','V-641B','V-642','V-643A','V-643B'}
    unit = '吨/立方米'
    for name in names :
        cursor.execute("select 数据 from 生产信息 where 名称=%s and 单位=%s and 日期<=%s order by 日期 desc limit 1",[name,unit,d])
        row = cursor.fetchone()
        data = row[0] if row else 0
        name = name.replace('-','') + '密度'
        context[name] = data
        # print(d,name,data)

    cursor.execute("select sum(数据) from 生产信息 where 日期=%s and 名称 in ('V-631A','V-631B','V-631C') and 单位='吨' ;",[lastday])
    row = cursor.fetchone()
    data = row[0]
    context['昨轻油库存t'] = data
    cursor.execute("select sum(数据) from 生产信息 where 日期=%s and 名称 in ('V-641A','V-641B','V-642','V-643A','V-643B') and 单位='吨' ;",[lastday])
    row = cursor.fetchone()
    data = row[0] if row else 0
    context['昨轻烃库存t'] = data

def getDerivedData(context,d):
    getRelatedData(context,d)
    names = {
        '稳定区',
        '入厂计量',
        '锦天化',
        '精细化工',
        '污水处理厂',
        '新奥燃气',
        '自用气',
    }
    for name in names :
        context[name+'月累'] = context[name+'数据'] + context[name+'昨月累']
        context[name+'年累'] = context[name+'数据'] + context[name+'昨年累']

    去年年末 = date(d.year-1,12,31)
    今年年末 = date(d.year,12,31)
    年时间进度比 = (d - 去年年末) / (今年年末 - 去年年末) * 100
    context['年时间进度比']    = 年时间进度比
    总外输气量数据=context['锦天化数据']+context['精细化工数据']+context['污水处理厂数据']+context['新奥燃气数据']
    context['天然气数据']=context['总外输气量数据']=总外输气量数据
    context['总产气量数据']=总外输气量数据 + context['自用气数据']

    context['JZ202体系接收月累'] = context['JZ202体系接收数据'] + context['JZ202体系接收昨月累']
    context['JZ202体系接收年累'] = context['JZ202体系接收数据'] + context['JZ202体系接收昨年累']
    bili = context['JZ202体系接收数据'] / context['入厂计量数据']
    context['JZ251S体系接收数据'] = context['入厂计量数据'] - context['JZ202体系接收数据']
    context['JZ251S体系接收月累'] = context['入厂计量月累'] - context['JZ202体系接收月累']
    context['JZ251S体系接收年累'] = context['入厂计量年累'] - context['JZ202体系接收年累']

    context['总外输气量昨年累'] = context['锦天化昨年累'] + context['精细化工昨年累'] + context['污水处理厂昨年累'] + context['新奥燃气昨年累']
    context['总外输气量昨月累'] = context['锦天化昨月累'] + context['精细化工昨月累'] + context['污水处理厂昨月累'] + context['新奥燃气昨月累']
    context['天然气年累'] = context['总外输气量年累'] = context['总外输气量数据'] + context['总外输气量昨年累']
    context['天然气月累'] = context['总外输气量月累'] = context['总外输气量数据'] + context['总外输气量昨月累']
    context['天然气年度完成率'] = context['天然气年累']/context['天然气年配产'] * 100
    context['天然气月度完成率'] = context['天然气月累']/context['天然气月配产'] * 100
    context['天然气需日产'] = (context['天然气年配产']-context['天然气年累'])/(今年年末-d ).days
    context['总产气量月累']  = context['总外输气量昨月累'] + context['自用气月累']
    context['总产气量年累']  = context['总外输气量昨年累'] + context['自用气月累']

    context['JZ202体系外输数据'] = context['总外输气量数据'] * bili
    context['JZ202体系外输月累'] = context['JZ202体系外输数据'] + context['JZ202体系外输昨月累']
    context['JZ202体系外输年累'] = context['JZ202体系外输数据'] + context['JZ202体系外输昨年累']
    context['JZ251S体系外输数据'] = context['总外输气量数据'] - context['JZ202体系外输数据']
    context['JZ251S体系外输月累'] = context['总外输气量月累'] - context['JZ202体系外输月累']
    context['JZ251S体系外输年累'] = context['总外输气量年累'] - context['JZ202体系外输年累']

    if context['海管进口温度'] and context['海管出口温度'] :
      context['海管进出口温度'] = '{}/{}'.format(context['海管进口温度'],context['海管出口温度'])
    if context['海管进口压力'] and context['海管出口压力'] :
      context['海管进出口压力'] = '{}/{}'.format(context['海管进口压力'],context['海管出口压力'])
    if context['数据库轻油回收量m3'] :
        context['JZ202轻油数据'] = context['数据库轻油回收量m3'] - context['JZ202凝析油数据']
        context['JZ202轻油密度'] = context['JZ202凝析油密度']

    # 轻油罐体积系数
    qx = 165
    names = {'V631A_m','V631B_m','V631C_m','V641A_m','V641B_m','V642_m','V643A_m','V643B_m'}
    r = 6.15
    sw=sv=0
    context['丙烷库存m3'] = context['丁烷库存m3'] = context['液化气库存m3'] = 0
    context['丙烷库存t'] = context['丁烷库存t'] = context['液化气库存t'] = 0
    轻烃库存t = 0
    for name in names :
        if re.match('V631',name) :
            s = name.replace('m','m3')
            # print(name,s,context[name]*qx)
            v = context[name]*qx
            sv += v
            context[s] = v
            s = name.replace('m','t')
            w = context['轻油密度'] * v
            sw += w
            context[s] = w
            context['轻油库存m3'] = sv
            context['轻油库存t'] = sw
        if re.match('V64([13][AB]|2)',name) :
            s = name.replace('m','m3')
            h = context[name]
            v = round(pi*h*h*(3*r-h)/3,2)
            context[s] = v
            midu = name.replace('_m','密度')
            w = round(context[midu] * v,2)
            s = name.replace('_m','_t')
            context[s] = w
            轻烃库存t += w
            s = name.replace('_m','介质')
            if context[s] == '丙烷' :
                context['丙烷库存m3'] += v
                context['丙烷库存t'] += w
            if context[s] == '丁烷' :
                context['丁烷库存m3'] += v
                context['丁烷库存t'] += w
            if context[s] == '液化气' :
                context['液化气库存m3'] += v
                context['液化气库存t'] += w
            # print(name,v,context[midu],w,context['轻烃库存t'])

    context['轻油回收量t'] = context['轻油库存t'] + context['轻油装车t'] - context['昨轻油库存t']
    context['轻油回收量m3'] = context['轻油回收量t'] / context['轻油密度']
    x = 25
    context['轻油处理量m3'] =  context['轻油回收量m3'] + x
    context['轻油年累'] = context['轻油回收量m3'] + context['轻油回收量昨年累']
    context['轻油月累'] = context['轻油回收量m3'] + context['轻油回收量昨月累']
    context['轻油年度完成率'] = context['轻油年累']/context['轻油年配产'] * 100
    context['轻油月度完成率'] = context['轻油月累']/context['轻油月配产'] * 100
    context['轻油需日产'] = (context['轻油年配产']-context['轻油年累'])/(今年年末-d ).days

    丙烷密度 = context['V641A密度']
    context['丙烷装车m3'] = context['丙烷装车t'] / 丙烷密度
    丁烷密度 = context['V642密度']
    context['丁烷装车m3'] = context['丁烷装车t'] / 丁烷密度
    液化气密度 = context['V643A密度']
    context['液化气装车m3'] = context['液化气装车t'] / 液化气密度
    context['轻烃库存t'] = 轻烃库存t
    context['轻烃回收t'] = context['轻烃库存t'] + context['丙烷装车t'] + context['丁烷装车t'] + context['液化气装车t'] - context['昨轻烃库存t']
    轻烃密度 = 0.54
    context['轻烃回收m3'] = context['轻烃回收t'] / 轻烃密度
    context['丙丁烷年累'] = context['轻烃回收m3'] + context['丙丁烷回收量昨年累']
    context['丙丁烷月累'] = context['轻烃回收m3'] + context['丙丁烷回收量昨月累']
    context['丙丁烷年度完成率'] = context['丙丁烷年累']/context['丙丁烷年配产'] * 100
    context['丙丁烷月度完成率'] = context['丙丁烷月累']/context['丙丁烷月配产'] * 100
    context['丙丁烷需日产'] = (context['丙丁烷年配产']-context['丙丁烷年累'])/(今年年末-d ).days


    context['甲醇消耗m3月累'] = context['甲醇消耗m3'] + context['甲醇消耗昨月累']
    context['甲醇消耗m3年累'] = context['甲醇消耗m3'] + context['甲醇消耗昨年累']
    context['乙二醇回收m3月累'] = context['乙二醇回收m3'] + context['乙二醇回收昨月累']
    context['乙二醇回收m3年累'] = context['乙二醇回收m3'] + context['乙二醇回收昨年累']

    x = 1390
    context['库存水m3'] = context['库存水m'] * x
    context['水消耗m3'] = context['外供水m3'] + context['自采水m3'] + context['昨库存水m3'] -context['库存水m3']
    context['外供水m3月累'] = context['外供水m3'] + context['外供水昨月累']
    context['外供水m3年累'] = context['外供水m3'] + context['外供水昨年累']
    context['自采水m3月累'] = context['自采水m3'] + context['自采水昨月累']
    context['自采水m3年累'] = context['自采水m3'] + context['自采水昨年累']
    context['水消耗m3月累'] = context['水消耗m3'] + context['水消耗昨月累']
    context['水消耗m3年累'] = context['水消耗m3'] + context['水消耗昨年累']

    context['电消耗KWh'] = context['外供电KWh'] -context['自发电KWh']
    context['外供电KWh月累'] = context['外供电KWh'] + context['外供电昨月累']
    context['外供电KWh年累'] = context['外供电KWh'] + context['外供电昨年累']
    context['自发电KWh月累'] = context['自发电KWh'] + context['自发电昨月累']
    context['自发电KWh年累'] = context['自发电KWh'] + context['自发电昨年累']
    context['电消耗KWh月累'] = context['电消耗KWh'] + context['电消耗昨月累']
    context['电消耗KWh年累'] = context['电消耗KWh'] + context['电消耗昨年累']
#    print(context)

# 获得基础数据
def getBaseData(context,date):
    getDistributionData(context,date)
    getUpstreamData(context,date)
    getSeaPipeData(context,date)
    getGasData(context,date)
    getOilData(context,date)
    getHydrocarbonData(context,date)
    getChemicalsData(context,date)
    getWaterData(context,date)
    getPowerData(context,date)
    getRemark(context,date)

# 获得生产日报数据
def ProductionDailyData(year,month,day):
    context = {}
    日期=date(int(year),int(month),int(day))
    getBaseData(context,日期)
    getDerivedData(context,日期)
    context['Title'] = '生产日报'
    context['日期'] = 日期
    pattern = '月累|年累'
    for k,v in context.items():
        context[k] = v if v else '/'
        # if isinstance(v,str) :
        #     print(k,v)
        if re.search(pattern,k):
            v = v / 10000
        if isinstance(v,float) :
            if re.search('bbl|密度|月累|年累',k) :
                # print(k,v)
                context[k] = round(v,4)
            else :
                context[k] = round(v,2)
        # print(k,v,isinstance(v,float),re.match(pattern,k))
    return context

