from django.shortcuts import render
from django.http import HttpResponse
from django.db.models import Q
from datetime import date,datetime,time
from .models import 生产信息
from .ReportFormData import ProductionDailyData
from django.views.generic import ListView
from django.db.models import Q
from django.db import connection
from django.http import JsonResponse
# Create your views here.
def index(request):
    title='工艺生产'
    用户='游客'
    数据采集 = (
    ('配产数据','Proration'),
    ('快速录入','QuickInput'),
    ('装车数据','OutputData'),
    ('海管数据','SeaPipeData'),
    ('化验数据','TestData'),
    )
    报表 = (
    ('海管报表','SeaPipeReport'),
    ('装车报表','OutputReport'),
    ('化验报表','TestReport'),
    ('生产信息','ProductionDataList'),
    ('生产动态','ProductionStatusList'),
    ('生产日报','ProductionDaily'),
    ('生产月报','MonthlyProduction'),
    ('生产年报','AnnualProduction'),
    )
    return render(request, 'ProcessProduction/index.html', locals())

def ProductionDataList(request):
    Title = "生产信息"
    tableName = "生产信息"
    columns = ['日期','名称','单位','数据','类别','状态','备注','月累','年累']
    return render(request,'ProcessProduction/ProductionDataList.html',locals())

def ProductionData(request):
    cursor = connection.cursor()
    cursor.execute("select 日期,名称,单位,数据,类别,状态,备注,月累,年累 from 生产信息 limit 9;")
    rows = cursor.fetchall()
    record = list()
    data = list()
    for row in rows:
        for field in row:
            if isinstance(field,(date,datetime,time)):
                # record.append(field.strftime('%Y-%m-%d'))
                record.append(field.isoformat())
                continue
            if isinstance(field,(int,float)):
                record.append(str(field))
                continue
            if field :
                record.append(field)
            else:
                record.append('')
        data.append(record)
    # print(data)
    # data = json.dumps(data,indent=4)
    return JsonResponse(data, safe=False)

def ProductionStatusList(request):
    Title = "生产动态"
    tableName = "生产动态"
    columns = ['时间','名称','单位','数据','类别','备注']
    return render(request,'ProcessProduction/ProductionStatusList.html',locals())

def ProductionStatus(request):
    Title = "生产动态"
    tableName = "生产动态"
    cursor = connection.cursor()
    cursor.execute("select 时间,名称,单位,数据,类别,备注 from 生产动态 limit 36;")
    rows = cursor.fetchall()
    record = list()
    data = list()
    for row in rows:
        for field in row:
            if isinstance(field,(date,datetime,time)):
                # record.append(field.strftime('%Y-%m-%d %'))
                record.append(field.isoformat())
                continue
            if isinstance(field,(int,float)):
                record.append(str(field))
                continue
            if field :
                record.append(field)
            else:
                record.append('')
        data.append(record)
    # print(data)
    # data = json.dumps(data,indent=4)
    return JsonResponse(data, safe=False)

def ProductionAnnual(request,year):
	return render(request,'ProcessProduction/ProductionAnnual.html', locals())

def ProductionMonthly(request,year,month):
	return render(request,'ProcessProduction/ProductionMonthly.html',locals())

def ProductionDaily(request,year='',month='',day=''):
    if year and month and day:
        日期=date(int(year),int(month),int(day))
    else:
        cursor = connection.cursor()
        cursor.execute("select max(日期) from 生产信息 ;")
        row = cursor.fetchone()
        日期 = row
    context = ProductionDailyData(日期)
    return render(request,'ProcessProduction/ProductionDaily.html',context)
