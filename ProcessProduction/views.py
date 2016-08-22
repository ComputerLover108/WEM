from django.shortcuts import render
from django.http import HttpResponse
from django.db.models import Q
from datetime import date,datetime,time
from .models import 生产信息,生产动态,提单
from .ReportFormData import ProductionDailyData
from django.views.generic import ListView
from django.db.models import Q
from django.db import connection


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
    ('生产日报','ProductionDaily'),
    ('生产月报','MonthlyProduction'),
    ('生产年报','AnnualProduction'),
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