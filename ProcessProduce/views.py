# -*- coding: utf-8 -*-
from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from django.db import connection
from django.forms.formsets import formset_factory
from django.forms import ModelForm
from datetime import date,datetime
import sys
import json

from . forms import ProrationForm,QuickInputFrom
from . models import 生产信息,生产动态,提单


def BillOfLading():
    pass
    
# Create your views here.
def index(request):
    title='工艺生产'
    用户='游客'
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
#def TestData(request):
#    title='化验录入'
#    return render(request, 'ProcessProduce/TestData.html', locals())

def TestDaily(request,year,month,day):
    title='化验日报'
    日期=date(int(year),int(month),int(day))
    return render(request, 'ProcessProduce/TestDaily.html', locals())

#def QuickInput(request):
#    title='快速录入'   
#
#    categorys=['天然气','轻油','轻烃','化学药剂','水','电','数据库','上游']
#    气=['入厂计量 Nm3','稳定区产气 Nm3','外供锦天化 Nm3','外供精细化工 Nm3','外供污水处理厂 Nm3','外供新奥燃气 Nm3','自用气 Nm3','JZ202体系 Nm3']
#    油=['V-631A m','V-631B m','V-631C m']
#    轻烃=['V-641A m','V-641B m','V-642 m','V-643A m','V-643B m']
#    化学药剂=['甲醇日耗量 m3','乙二醇日耗量 m3','乙二醇日回收量 m3','乙二醇浓度 %']  
#    水=['水池水位 m','污水排放 m3','自采水 m3','外供水 m3']  
#    电=['外供电 kwh','自发电 kwh']  
#    上游=['JZ20-2体系供气 Nm3','JZ25-1S原油密度','JZ20-2凝析油m3','JZ20-2轻油m3','JZ9-3供气10KNm3','JZ21-1供气10KNm3','JZ25-1供气10KNm3','JZ25-1S供气10KNm3']  
#    数据库=['数据库轻油回收量m3','数据库丙丁烷回收量m3']
#
#    if request.method == 'POST':
#        form = QuickInputFrom(request.POST)
#        if form.is_valid():
#            日期 = form.cleaned_data['日期']
#            稳定区 = form.cleaned_data['稳定区']
#            入厂计量 = form.cleaned_data['入厂计量']
#            锦天化 = form.cleaned_data['锦天化']
#            精细化工 = form.cleaned_data['精细化工']
#            污水处理厂 = form.cleaned_data['污水处理厂']
#            新奥燃气 = form.cleaned_data['新奥燃气']
#            自用气 = form.cleaned_data['自用气']
#            JZ202体系 = form.cleaned_data['JZ202体系']
#            address='/ProcessProduce/DailyProduction/{}/'.format(日期)
#            return HttpResponseRedirect(address)pass
#    else:
#        form = QuickInputFrom()
#    return render(request, 'ProcessProduce/QuickInput.html', locals())


#def Proration(request):
#    title="配产任务"
##    产品 = ["天然气","轻油","丙丁烷"]
#    if request.method == 'POST':
#        form = ProrationForm(request.POST)
#        if form.is_valid():
#            date = form.cleaned_data['日期']
#            gasM = form.cleaned_data['天然气月配产10KNm3']
#            gasY = form.cleaned_data['天然气月配产10KNm3']
#            oilM = form.cleaned_data['轻油月配产m3']
#            oilY = form.cleaned_data['轻油年配产m3']
#            bdM = form.cleaned_data['丙丁烷月配产m3']
#            bdY = form.cleaned_data['丙丁烷年配产m3']
#            bl=[]
#            gm=生产信息(日期=date,名称='天然气月配产',单位='方',数据=gasM*10000,类别='天然气',状态='计划')          
#            gy=生产信息(日期=date,名称='天然气年配产',单位='方',数据=gasY*10000,类别='天然气',状态='计划')
#            om=生产信息(日期=date,名称='轻油月配产',单位='方',数据=oilM,类别='轻油',状态='计划')
#            oy=生产信息(日期=date,名称='轻油年配产',单位='方',数据=oilY,类别='轻油',状态='计划')
#            qtm=生产信息(日期=date,名称='丙丁烷月配产',单位='方',数据=bdM,类别='丙丁烷',状态='计划')
#            qty=生产信息(日期=date,名称='丙丁烷年配产',单位='方',数据=bdY,类别='丙丁烷',状态='计划')
#            bl.append(gm)
#            bl.append(gy)
#            bl.append(om)
#            bl.append(oy)
#            bl.append(qtm)
#            bl.append(qty)
#            生产信息.objects.bulk_create(bl)
##            SQL="insert into 生产信息 (名称单位数据)"
#            SQL="delete from 生产信息 where id not in (select   max(id)   from   生产信息   group   by   日期,名称,单位)"
#            with connection.cursor() as c:
#                c.execute(SQL)            
#            address='/ProcessProduce/Proration/{}/'.format(date)
#            return HttpResponseRedirect(address)
#    else:
#        form = ProrationForm()
#    return render(request,'ProcessProduce/Proration.html',locals())
#    
#def RealData(request):
#    pass
#
##报表
def DailyProduction(request,year,month,day):
    title="生产日报"
    日期=date(int(year),int(month),int(day))
    return render(request,'ProcessProduce/DailyPaper.htm',locals())

#def MonthlyProduction():
#    pass
#
#def AnnualProduction():
#    pass
#
#def TestReport():
#    pass
#
#def SeaPipeStatus():
#    pass
#
#def OutputReport():
#    pass
#
#def ph(date):
#    rs=['天然气','轻油','丙丁烷']
#    cs=['月配产','年配产']
#    data=[]
#    for i in range(len(rs)):
#        r=[('名称',rs[i])]
#        with connection.cursor() as c:
#            for y in cs:
#                SQL="select 数据 from 生产信息 where 日期<='{0}'  and  名称='{1}' order by 日期 desc limit 1;".format(date,rs[i]+y)
#                print(SQL)
#                c.execute(SQL)
#                temp=(y,c.fetchone()[0])                
#                r.append(temp)
##        print( r )
#        data.append({'id':i+1,'values':dict(r)})
#        del r[:]
##    print(data)
#    return(data)
#            
#    
#def ProrationReport(request,date):
#    title='配产表'
#    td=[]
#    td.append({ "name": "名称", "label": "名称", "datatype": "string", "editable": True})
#    td.append({ "name": "月配产", "label": "月配产", "datatype": "double", "editable": True})
#    td.append({ "name": "年配产", "label": "年配产", "datatype": "doulbe", "editable": True})
#
#    dd=ph(date)
#    print(td,dd)
##    print(sys.getdefaultencoding())
##    print(json.dumps(dd, ensure_ascii=False))
##    with open('prorationReport.json', 'w+') as outfile:
##        json.dump(td,outfile,ensure_ascii=False,indent=4)
##        json.dump(dd,outfile,ensure_ascii=False,indent = 4)        
##        rs=[x[0] for x in c.fetchall() ]
#    return render(request, 'ProcessProduce/ProrationReport.html', 
#                  {
#                  'title':title,'date':date,
#                  'metadata':json.dumps(td),'data':json.dumps(dd)}
#                  )
