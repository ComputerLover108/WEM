from django.shortcuts import render
from django.http import HttpResponse
from django.db.models import Q
from datetime import date,datetime,time

from django.views.generic import ListView
from django.db.models import Q
from django.db import connection

from .productionData import *
from .models import 生产信息,生产动态,提单
from .ReportFormData import *

import logging
logging.basicConfig(level=logging.DEBUG,  
                    format='%(asctime)s %(filename)s%(module)s%(funcName)s[line:%(lineno)d] %(levelname)s %(message)s',  
                    datefmt='%b %Y-%b-%d %H:%M:%S',  
                    filename='/tmp/HLD.log',  
                    filemode='w')

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
    # ('生产日报','ProductionDaily'),
    # ('生产月报','MonthlyProduction'),
    # ('生产年报','AnnualProduction'),
    ('生产信息','ProductionDataList'),
    ('生产动态','ProductionStatusList'),
    ('提单','LadingBill'),    
    )
    return render(request, 'ProcessProduction/index.html', locals())

class ProductionDataList(ListView):
    template_name = "ProcessProduction/ProductionDataList.html"
    model = 生产信息
    fields = ['日期','名称','单位','数据','类别','状态','备注','月累','年累']
    context_object_name = 'ProductionDataList'    
    paginate_by = 16
    def get_queryset(self):
        queryset =生产信息.objects.all().order_by('日期','名称','单位','类别','状态','备注')
        # keyword = self.request.GET.get('keyword')
        # if keyword :
        #     queryset = 生产信息.objects.filter(Q(地点__icontains=keyword)|Q(电话__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
        return queryset
    def get_context_data(self, **kwargs):
        context = super(ProductionDataList, self).get_context_data(**kwargs)
        context['Title'] = "生产信息"
        return context


class ProductionStatusList(ListView):
    template_name = "ProcessProduction/ProductionStatusList.html"
    model = 生产动态
    context_object_name = 'ProductionStatusList'    
    paginate_by = 16
    def get_queryset(self):
        queryset =生产动态.objects.all().order_by('时间','名称','单位','类别','备注')
        # keyword = self.request.GET.get('keyword')
        # if keyword :
        #     queryset = 生产动态.objects.filter(Q(地点__icontains=keyword)|Q(电话__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
        return queryset
    def get_context_data(self, **kwargs):
        context = super(ProductionStatusList, self).get_context_data(**kwargs)
        context['Title'] = "生产动态"
        return context

class LadingBill(ListView):
    template_name = "ProcessProduction/LadingBill.html"
    model = 提单
    context_object_name = 'LadingBill'
    paginate_by = 16
    def get_queryset(self):
        queryset = 提单.objects.all().order_by('提单号','日期','产品名称','客户名称','备注')
        return queryset
    def get_context_data(self,**kwargs):
        context = super(LadingBill,self).get_context_data(**kwargs)
        context['Title'] = "提单"
        return context
        
def ProductionAnnual(request):
	return render(request,'ProcessProduction/ProductionAnnual.html', locals())

def ProductionMonthly(request):
	return render(request,'ProcessProduction/ProductionMonthly.html',locals())

def ProductionDaily(request):
    date=request.GET.get('Date')
    data = getProductionDailyData(date)
    logging.debug(data)    
    return render(request,'ProcessProduction/ProductionDaily.html',locals())


def productionReview(request):
    Title = "生产情况"
    table = "生产信息"
    specifiedDate = getAvailableTime(table,date.today())
    startDate = getAvailableTime(table,date(date.today().year,1,1),upLimit=False)
    endDate = getAvailableTime(table,date.today())
      
    x = getProductionCompletion(specifiedDate)
    pc =[
        x['总外输气量月累']/(10**4),x['总外输气量年累']/(10**4),
        x['轻油回收量月累'],x['轻油回收量年累'],
        x['丙丁烷回收量月累'],x['丙丁烷回收量年累'],
        ]
    dc = [
        x['天然气月配产']/(10**4),x['天然气年配产']/(10**4),
        x['轻油月配产'],x['轻油年配产'],
        x['丙丁烷月配产'],x['丙丁烷年配产'],    
    ]
    xx = [
        '天然气月完10km3','天然气年完万方10km3',
        '轻油月完m3','轻油年完m3',
        '丙丁烷月完m3','丙丁烷年完m3', 
    ]
    # print(x)
    production = getProductionDataSet(startDate,endDate)
    received = getRecivedDataSet(startDate,endDate)
    output = getOutputDataSet(startDate,endDate)
    consumption = getConsumptionDataSet(startDate,endDate)
    inventory = getInventoryDataSet(startDate,endDate)
    dt = dateList(startDate,endDate)
    xAxis = [d.isoformat() for d in dt]
    legendProduction = list(production.keys())
    legendReceived = list(received.keys())
    legendOutput = list(output.keys())
    legendConsumption = list(consumption.keys())
    legendInventory = list(inventory.keys())   
    for x in production:
        production[x]=mend(production[x],dt,0)
    for x in received:
        received[x]=mend(received[x],dt,0)
    for x in output:
        output[x]=mend(output[x],dt,0)
    for x in consumption:
        consumption[x]=mend(consumption[x],dt,0)
    for x in inventory:
        inventory[x]=mend(inventory[x],dt,0)                       
    return render(request, 'ProcessProduction/productionReview.html', locals())