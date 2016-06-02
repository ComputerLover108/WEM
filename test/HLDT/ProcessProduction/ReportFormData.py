from django.db.models import Q
from datetime import date
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
	# 海管来液含水<V-601>%
	# 海管MEG浓度 <V-611>%
	# 海管出口凝点℃<V-601>
	# 海管出口PH值
	# 海管进/出口压力MPa
	# 海管进/出口温度℃
    category = '海管'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records :
       print('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(record.名称,record.单位,record.数据,record.类别,record.状态,record.月累,record.年累,record.备注))        

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
                print(name,record.数据)
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
            context[name+'月累'] = record.月累
            context[name+'年累'] = record.年累
    name='JZ20-2体系'
    state='接收'
    record=getData(date,name,unit,category,state)
    name = 'JZ202体系接收'
    context[name+'数据'] = record.数据
    context[name+'月累'] = record.月累
    context[name+'年累'] = record.年累

def getOilData(context,date):
    category = '轻油'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
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
        if record.名称 == '轻油处理量' :
                context['轻油处理量m3'] = record.数据
        if record.名称 == '轻油回收量' and record.单位 == '方' :
                context['轻油回收量m3'] = record.数据
        if record.名称 == '轻油回收量' and record.单位 == '吨' :
                context['轻油回收量t'] = record.数据
        if record.名称 == '轻油入罐前含水' :
            x=y='-'
            if record.备注 == '上午' :
                x = record.数据
            if record.备注 == '下午' :
                y = record.数据
        pattern = '数据库轻油回收量'
        if re.match(pattern,record.名称):
            name = '数据库轻油回收量m3'
            context[name] = record.数据


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
            context[name+'月累'] = record.月累
            context[name+'年累'] = record.年累
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
            context[name+'月累'] = record.月累
            context[name+'年累'] = record.年累
        if record.名称 == '库存水' and record.单位 == '米' :
            name = '水池水位'
            context[name] = record.数据

def getPowerData(context,date):
    category = '电'
    records = 生产信息.objects.filter(Q(日期=date),Q(类别=category))
    for record in records:
        pattern = '外供电|自发电'
        if re.match(pattern,record.名称) :
            name = record.名称 + 'KWh'
            context[name] = record.数据
            context[name+'月累'] = record.月累
            context[name+'年累'] = record.年累

def getRemark(context,date):
	names = ['上下游12吋海管通球','生产备注']
	records = 生产信息.objects.filter(Q(日期=date),Q(名称__in=names))
	for record in records :
		context[record.名称] = record.备注

def getDerivedData(context,d):
    去年年末 = date(d.year-1,12,31)
    今年年末 = date(d.year,12,31)
    年时间进度比 = (d - 去年年末) / (今年年末 - 去年年末) * 100
    context['年时间进度比']    = 年时间进度比
    总外输气量数据=context['锦天化数据']+context['精细化工数据']+context['污水处理厂数据']+context['新奥燃气数据']
    总外输气量月累=context['锦天化月累']+context['精细化工月累']+context['污水处理厂月累']+context['新奥燃气月累']
    总外输气量年累=context['锦天化年累']+context['精细化工年累']+context['污水处理厂年累']+context['新奥燃气年累']
    context['天然气数据']=context['总外输气量数据']=总外输气量数据
    context['天然气月累']=context['总外输气量月累']=总外输气量月累
    context['天然气年累']=context['总外输气量年累']=总外输气量年累

    context['总产气量数据']=总外输气量数据 + context['自用气数据']
    context['总产气量月累']=总外输气量月累 + context['自用气月累']
    context['总产气量年累']=总外输气量年累 + context['自用气年累']

    bili = context['JZ202体系接收数据'] / context['入厂计量数据']
    context['JZ251S体系接收数据'] = context['入厂计量数据'] - context['JZ202体系接收数据']
    context['JZ251S体系接收月累'] = context['入厂计量月累'] - context['JZ202体系接收月累']
    context['JZ251S体系接收年累'] = context['入厂计量年累'] - context['JZ202体系接收年累']

    context['JZ202体系外输数据'] = context['总外输气量数据'] * bili
    context['JZ251S体系外输数据'] = context['总外输气量数据'] - context['JZ202体系外输数据']

    context['天然气年度完成率'] = context['天然气年累']/context['天然气年配产'] * 100
    context['天然气月度完成率'] = context['天然气月累']/context['天然气月配产'] * 100
    context['天然气需日产'] = (context['天然气年配产']-context['天然气年累'])/(今年年末-d ).days
#    print(context)

# 获得生产日报数据
def ProductionDailyData(year,month,day):
    context = {}
    日期=date(int(year),int(month),int(day))
    getDistributionData(context,日期)
    getUpstreamData(context,日期)
    getSeaPipeData(context,日期)
    getGasData(context,日期)
    getOilData(context,日期)
    getHydrocarbonData(context,日期)
    getChemicalsData(context,日期)
    getWaterData(context,日期)
    getPowerData(context,日期)
    getDerivedData(context,日期)
    getRemark(context,日期)
    context['Title'] = '生产日报'
    context['日期'] = 日期

    for k,v in context.items():
        # print(k,v)
        context[k] = v if v else '/'
    return context

