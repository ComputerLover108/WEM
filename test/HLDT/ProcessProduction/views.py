from django.shortcuts import render
from django.db.models import Q
from datetime import date
from .models import 生产信息
from .ReportFormData import ProductionDailyData
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
    ('生产动态','ProductionStatus'),
    ('生产日报','DailyProduction'),
    ('生产月报','MonthlyProduction'),
    ('生产年报','AnnualProduction'),
    )
    return render(request, 'ProcessProduction/index.html', locals())

def ProductionAnnual(request,year):
	return render(request,'ProcessProduction/ProductionAnnual.html', locals())

def ProductionMonthly(request,year,month):
	return render(request,'ProcessProduction/ProductionMonthly.html',locals())

def ProductionDaily(request,year,month,day):
	context = ProductionDailyData(year,month,day)
	return render(request,'ProcessProduction/ProductionDaily.html',context)