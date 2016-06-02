from django.shortcuts import render
from django.db.models import Q
from datetime import date
from .models import 生产信息
from .ReportFormData import ProductionDailyData
# Create your views here.
def ProductionAnnual(request,year):
	return render(request,'ProcessProduction/ProductionAnnual.html', locals())

def ProductionMonthly(request,year,month):
	return render(request,'ProcessProduction/ProductionMonthly.html',locals())

def ProductionDaily(request,year,month,day):
	context = ProductionDailyData(year,month,day)
	return render(request,'ProcessProduction/ProductionDaily.html',context)