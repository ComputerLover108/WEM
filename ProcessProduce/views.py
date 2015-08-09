# -*- coding: utf-8 -*-
from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from django.db import connection
from django.forms.formsets import formset_factory
from datetime import date,datetime
import sys
import json

from . forms import ProrationForm,QuickInputFrom
from . models import 生产信息,生产动态,提单

# Create your views here.
def index(request):
    title='工艺生产'
    用户='游客'
##    背景图片='/static/images/工艺生产.jpg'
    buttons=(
        ('配产','Proration'),
        ('快速录入','QuickInput'),
        ('化验数据','TestData'),
        ('海管数据','SeaPipeData'),
        ('装车数据','OutputData'),
        ('海管报表','SeaPipeReport'),
        ('装车报表','OutputReport'),
        ('化验报表','TestReport'),
        ('生产动态','ProductionStatus'),
        ('生产日报','DailyProduction'),
        ('生产月报','MonthlyProduction'),
        ('生产年报','AnnualProduction'),
 
    )
    return render(request, 'ProcessProduce/index.html', locals())

#数据录入
def TestData(request):
    title='化验录入'
    return render(request, 'ProcessProduce/TestData.html', locals())

def QuickInput(request):
    title='快速录入'   
#    with connection.cursor() as c:
#        SQL="select distinct 类别 from 生产信息 order by 类别;"
#        c.execute(SQL)
#        categorys=[x[0] for x in c.fetchall() if x[0] != '' ]
#        categorys.sort()
#        print(categorys)
    categorys=['天然气','轻油','轻烃','化学药剂','水','电','数据库','上游']
    天然气=['入厂计量Nm3','稳定区产气Nm3','外供锦天化Nm3','外供精细化工Nm3','外供污水处理厂Nm3','外供新奥燃气Nm3','自用气Nm3']
    轻油=['V-631A(液位m)','V-631B(液位m)','V-631C(液位m)']
    轻烃=['V-641A(液位m)','V-641B(液位m)','V-642(液位m)','V-643A(液位m)','V-643B(液位m)']
    化学药剂=['乙二醇消耗m3','乙二醇消耗m3']  
    水=['污水排放m3','水池水位m','自采水m3','外供水m3']  
    电=['外供电kwh','自发电kwh']  
    上游=['JZ20-2体系供气Nm3','JZ25-1S原油密度','JZ20-2凝析油m3','JZ20-2轻油m3','JZ9-3供气10KNm3','JZ21-1供气10KNm3','JZ25-1供气10KNm3','JZ25-1S供气10KNm3']  
    数据库=['数据库轻油回收量m3','数据库丙丁烷回收量m3']
    Date=date.today().isoformat()
    表格=(
            ('上游','JZ9-3供气10KNm3'),
            ('上游','JZ21-1供气10KNm3'),
            ('上游','JZ25-1供气10KNm3'),
            ('上游','JZ25-1S供气10KNm3'),
            ('上游','JZ25-1S原油密度'),
            ('上游','JZ20-2凝析油m3'),
            ('上游','JZ20-2轻油m3'),
            ('数据库','数据库轻油回收量m3'),
            ('数据库','数据库丙丁烷回收量m3'),
            ('天然气','JZ20-2体系供气Nm3'),
            ('天然气','入厂计量Nm3'),
            ('天然气','稳定区产气Nm3'),
            ('天然气','外供锦天化Nm3'),
            ('天然气','外供精细化工Nm3'),
            ('天然气','外供污水处理厂Nm3'),
            ('天然气','外供新奥燃气Nm3'),
            ('天然气','自用气Nm3'),
            ('轻油','V-631A(液位m)'),
            ('轻油','V-631B(液位m)'),
            ('轻油','V-631C(液位m)'),
            ('轻烃','V-641A(液位m)'),
            ('轻烃','V-641B(液位m)'),
            ('轻烃','V-642(液位m)'),
            ('轻烃','V-643A(液位m)'),
            ('轻烃','V-643B(液位m)'),
            ('化学药剂','乙二醇消耗m3'),
            ('化学药剂','甲醇消耗m3'),
            ('水','外供水m3'),
            ('水','自采水m3'),
            ('水','污水排放m3'),
            ('水','水池水位m'),
            ('电','外供电kwh'),
            ('电','自发电kwh')
        )
    td=dict()
    for x in 表格:
        td[x[1]]=x[0]
#    print(td)
    rows= range(len(表格))
    columns= range(3)
    if request.method == 'POST':
        print(request.POST)
    return render(request, 'ProcessProduce/QuickInput.html', locals())

 
def Proration(request):
    title="配产任务"
#    产品 = ["天然气","轻油","丙丁烷"]
    if request.method == 'POST':
        form = ProrationForm(request.POST)
        if form.is_valid():
            date = form.cleaned_data['日期']
            gasM = form.cleaned_data['天然气月配产10KNm3']
            gasY = form.cleaned_data['天然气月配产10KNm3']
            oilM = form.cleaned_data['轻油月配产m3']
            oilY = form.cleaned_data['轻油年配产m3']
            bdM = form.cleaned_data['丙丁烷月配产m3']
            bdY = form.cleaned_data['丙丁烷年配产m3']
            bl=[]
            gm=生产信息(日期=date,名称='天然气月配产',单位='方',数据=gasM*10000,类别='天然气',状态='计划')          
            gy=生产信息(日期=date,名称='天然气年配产',单位='方',数据=gasY*10000,类别='天然气',状态='计划')
            om=生产信息(日期=date,名称='轻油月配产',单位='方',数据=oilM,类别='轻油',状态='计划')
            oy=生产信息(日期=date,名称='轻油年配产',单位='方',数据=oilY,类别='轻油',状态='计划')
            qtm=生产信息(日期=date,名称='丙丁烷月配产',单位='方',数据=bdM,类别='丙丁烷',状态='计划')
            qty=生产信息(日期=date,名称='丙丁烷年配产',单位='方',数据=bdY,类别='丙丁烷',状态='计划')
            bl.append(gm)
            bl.append(gy)
            bl.append(om)
            bl.append(oy)
            bl.append(qtm)
            bl.append(qty)
            生产信息.objects.bulk_create(bl)
#            SQL="insert into 生产信息 (名称单位数据)"
            SQL="delete from 生产信息 where id not in (select   max(id)   from   生产信息   group   by   日期,名称,单位)"
            with connection.cursor() as c:
                c.execute(SQL)            
            address='/ProcessProduce/Proration/{}/'.format(date)
            return HttpResponseRedirect(address)
    else:
        form = ProrationForm()
    return render(request,'ProcessProduce/Proration.html',locals())
    
def RealData(request):
    pass

#报表
def DailyProduction(request,date=date.today()):
    pass

def MonthlyProduction():
    pass

def AnnualProduction():
    pass

def TestReport():
    pass

def SeaPipeStatus():
    pass

def OutputReport():
    pass

def ph(date):
    rs=['天然气','轻油','丙丁烷']
    cs=['月配产','年配产']
    data=[]
    for i in range(len(rs)):
        r=[('名称',rs[i])]
        with connection.cursor() as c:
            for y in cs:
                SQL="select 数据 from 生产信息 where 日期<='{0}'  and  名称='{1}' order by 日期 desc limit 1;".format(date,rs[i]+y)
                print(SQL)
                c.execute(SQL)
                temp=(y,c.fetchone()[0])                
                r.append(temp)
#        print( r )
        data.append({'id':i+1,'values':dict(r)})
        del r[:]
#    print(data)
    return(data)
            
    
def ProrationReport(request,date):
    title='配产表'
    td=[]
    td.append({ "name": "名称", "label": "名称", "datatype": "string", "editable": True})
    td.append({ "name": "月配产", "label": "月配产", "datatype": "double", "editable": True})
    td.append({ "name": "年配产", "label": "年配产", "datatype": "doulbe", "editable": True})

    dd=ph(date)
    print(td,dd)
#    print(sys.getdefaultencoding())
#    print(json.dumps(dd, ensure_ascii=False))
#    with open('prorationReport.json', 'w+') as outfile:
#        json.dump(td,outfile,ensure_ascii=False,indent=4)
#        json.dump(dd,outfile,ensure_ascii=False,indent = 4)        
#        rs=[x[0] for x in c.fetchall() ]
    return render(request, 'ProcessProduce/ProrationReport.html', 
                  {
                  'title':title,'date':date,
                  'metadata':json.dumps(td),'data':json.dumps(dd)}
                  )
