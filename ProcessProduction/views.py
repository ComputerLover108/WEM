from django.shortcuts import render
from django.db.models import Q
from datetime import date
from .models import 生产信息
from .ReportFormData import ProductionDailyData
from django.views.generic import ListView
from django.db.models import Q

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
    ('生产信息','ProductionData'),
    ('生产动态','ProductionStatus'),
    ('生产日报','DailyProduction'),
    ('生产月报','MonthlyProduction'),
    ('生产年报','AnnualProduction'),
    )
    return render(request, 'ProcessProduction/index.html', locals())

class ProductionDataList(ListView):
    template_name = "QHSE/ProductionData.html"
    model = 生产信息
    context_object_name = 'ProductionData'    
    paginate_by = 10
    def get_queryset(self):
        queryset = 生产信息.objects.all()
        keyword = self.request.GET.get('keyword')
        if keyword :
            queryset = 生产信息.objects.filter(Q(地点__icontains=keyword)|Q(电话__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
        else:
            queryset = 生产信息.objects.all()
        return queryset
    def get_context_data(self, **kwargs):
        context = super(ProductionData, self).get_context_data(**kwargs)
        context['Title'] = "生产信息"
        return context 

def ProductionAnnual(request,year):
	return render(request,'ProcessProduction/ProductionAnnual.html', locals())

def ProductionMonthly(request,year,month):
	return render(request,'ProcessProduction/ProductionMonthly.html',locals())

def ProductionDaily(request,year,month,day):
	context = ProductionDailyData(year,month,day)
	return render(request,'ProcessProduction/ProductionDaily.html',context)
