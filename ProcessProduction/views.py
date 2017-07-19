from django.shortcuts import render
from django.http import HttpResponse,JsonResponse,HttpResponseRedirect
from django.db.models import Q
from datetime import date, datetime, time

from django.views.generic import ListView
from django.db.models import Q
from django.db import connection

from .productionData import *
from .models import 生产信息, 生产动态, LadingBill
from .productionDaily import *
from .productionMonthly import *
from .loadingDaily import *
from .forms import QuickInputForm,ProrationForm
import json

from pypinyin import pinyin, lazy_pinyin

# Create your views here.


def index(request):
    title = '工艺生产'
    用户 = '游客'
    数据采集 = (
        ('配产数据', 'Proration'),
        ('快速录入', 'QuickInput'),
        ('装车数据', 'LadingBillForm'),
        ('海管数据', 'SeaPipeData'),
        ('化验数据', 'TestData'),
    )
    报表 = (
        ('海管报表', 'SeaPipeReport'),
        # ('装车报表', 'OutputReport'),
        ('化验报表', 'TestReport'),
        # ('生产日报','ProductionDaily'),
        # ('生产月报','MonthlyProduction'),
        # ('生产年报','AnnualProduction'),
        ('生产信息', 'ProductionDataList'),
        ('生产动态', 'ProductionStatusList'),
        ('提单', 'LadingBillList'),
    )
    return render(request, 'ProcessProduction/index.html', locals())


class ProductionDataList(ListView):
    template_name = "ProcessProduction/ProductionDataList.html"
    model = 生产信息
    fields = ['日期', '名称', '单位', '数据', '类别', '状态', '备注', '月累', '年累']
    context_object_name = 'ProductionDataList'
    paginate_by = 16

    def get_queryset(self):
        queryset = 生产信息.objects.all().order_by('-日期', '状态', '类别', '单位', '名称', '备注')
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
        queryset = 生产动态.objects.all().order_by('-时间', '类别', '名称', '单位', '备注')
        # keyword = self.request.GET.get('keyword')
        # if keyword :
        #     queryset = 生产动态.objects.filter(Q(地点__icontains=keyword)|Q(电话__icontains=keyword)|Q(备注__icontains=keyword)).order_by('地点','电话')
        return queryset

    def get_context_data(self, **kwargs):
        context = super(ProductionStatusList, self).get_context_data(**kwargs)
        context['Title'] = "生产动态"
        return context


class LadingBillList(ListView):
    template_name = "ProcessProduction/LadingBillList.html"
    model = LadingBill
    context_object_name = 'LadingBill'
    paginate_by = 16

    def get_queryset(self):
        queryset = LadingBill.objects.all().order_by('-日期', '提单号', '产品名称', '客户名称', '备注')
        return queryset

    def get_context_data(self, **kwargs):
        context = super(LadingBillList, self).get_context_data(**kwargs)
        context['Title'] = "提单"
        return context


def toHtmlSelectMenu(selects, name):
    result = '<select name="{}">'.format(name)
    result += '<option selected="selected"></option>'
    for x in selects:
        x = '<option class="{}">{}</option>'.format(x, x)
        result += x
    result += '</select>'
    return result


def arrange(temp):
   
    temp = [x.strip() for x in temp]
    temp = list(set(temp))
    result = sorted(temp, key=pinyin)

    return result


# @csrf_exempt
def ladingBillForm(request):
    today = date.today().isoformat()
    Title = '提单'
    names = ['日期', '提单号', '产品', '客户', '计划装车t',
             '实际装车t', '实际装车m3', '实际装车bbl', '装车数', '备注']
    # SQL = 'select DISTINCT 产品名称 from 提单 order by 产品名称 collate "zh_CN.utf8";'

    temp = LadingBill.objects.distinct(
        '产品名称').values_list('产品名称', flat=True)
    products = arrange(temp)

    temp = LadingBill.objects.distinct(
        '客户名称').values_list('客户名称', flat=True)
    customers = arrange(temp)

    sp = toHtmlSelectMenu(products, '产品')
    sc = toHtmlSelectMenu(customers, '客户')
    formInput = [
        '<input type="date" name="日期" value="' + today + '" >',
        '<input type="text" name="提单号">',
    ]
    formInput.append(sp)
    formInput.append(sc)
    # formInput += [
    #     '<input type="text" name="产品" >',
    #     '<input type="text" name="客户" >',
    # ]
    formInput += [
        '<input type="number" min="0.00" max="1000.00" step="0.01" name="计划装车t">',
        '<input type="number" min="0.00" max="1000.00" step="0.01" name="实际装车t">',
        '<input type="number" min="0.00" max="3000.00" step="0.01" name="实际装车m3">',
        '<input type="number" min="0.0000" max="8000.0000" step="0.0001" name="实际装车bbl">',
        '<input type="number" min="0" max="100" name="装车数">',
        '<input type="text" name="备注">'
    ]
    if request.method == "POST" and request.is_ajax():
        rawData = request.body.decode("utf-8")

        data = json.loads(rawData)
        isErase = False
        if 'save' in data.keys():
            records = data['save']
            # message = {'删除数据：': ''}
        if 'delete' in data.keys():
            isErase = True
            records = data['delete']
            # message = {'保存数据：': ''}
        for record in records:
            if record['日期'] and record['提单号'] and record['产品'] and record['客户'] and record['计划装车t'] and record['实际装车t'] and record['装车数']:
                m = LadingBill()
                m.日期 = record['日期']
                m.提单号 = record['提单号']
                m.产品名称 = record['产品']
                m.客户名称 = record['客户']
                m.计划装车t = float(record['计划装车t'])
                m.实际装车t = float(record['实际装车t'])
                if record['实际装车m3']:
                    m.实际装车m3 = float(record['实际装车m3'])
                if record['实际装车bbl']:
                    m.实际装车bbl = float(record['实际装车bbl'])
                m.装车数量 = int(record['装车数'])
                m.备注 = record['备注']

                if isErase:
                    m.delete()
                else:
                    m.save()
        return HttpResponse(json.dumps(records))
    return render(request, 'ProcessProduction/LadingBillForm.html', locals())


def SeaPipeData(request):
    today = date.today()
    Title = '海管数据'
    names = ['时间', '压力MPa', '温度℃', '流量Nm3/h']
    formInput = [
        '<input type="datetime" name="时间" value="00:00" >',
        '<input type="number" min="0.00" max="6.00" step="0.01" name="压力">',
        '<input type="number" min="-50" max="60" step="1" name="温度">',
        '<input type="number" min="0.00" max="50000" step="1" name="流量">',
    ]
    if request.method == "POST" and request.is_ajax():
        rawData = request.body.decode("utf-8")

        data = json.loads(rawData)
        isErase = False
        if 'save' in data.keys():
            records = data['save']
            # message = {'删除数据：': ''}
        if 'delete' in data.keys():
            isErase = True
            records = data['delete']
            # message = {'保存数据：': ''}
        for record in records:
            if record['时间'] and record['压力'] and record['温度']:
                m = LadingBill()
                m.时间 = record['时间']
                m.压力 = record['压力']
                m.温度 = record['温度']
                if record['流量']:
                    m.流量 = float(record['流量'])

                if isErase:
                    m.delete()
                else:
                    m.save()
        return HttpResponse(json.dumps(records))
    return render(request, 'ProcessProduction/SeaPipeData.html', locals())


def ProductionDaily(request):
    Title = '葫芦岛天然气终端厂生产日报'
    sd = request.GET.get('productionDailyDate')
    data = getProductionDailyData(sd)
    return render(request, 'ProcessProduction/ProductionDaily.html', locals())


def ProductionMonthly(request):
    Title = '葫芦岛天然气终端厂生产月报'
    sd = request.GET.get('productionMonthlyDate')
    data = getProductionMonthlyData(sd)

    return render(request, 'ProcessProduction/ProductionMonthly.html', locals())


def ProductionAnnual(request):
    return render(request, 'ProcessProduction/ProductionAnnual.html', locals())


# 装车日报
def loadingDaily(request):
    Title = '葫芦岛天然气终端厂装车日报'
    tableName = 'loadingDaily'
    sd = request.GET.get('loadingDailyDate')
    data = getLoadingData(sd)
    times = ['日累', '月累', '年累']
    return render(request, 'ProcessProduction/loadingDaily.html', locals())


def productionReview(request):
    Title = "生产情况"
    table = "生产信息"
    specifiedDate = getAvailableTime(table, date.today())
    startDate = getAvailableTime(table, date(
        date.today().year, 1, 1), upLimit=False)
    endDate = getAvailableTime(table, date.today())

    x = getProductionCompletion(specifiedDate)
    pc = [
        x['总外输气量月累'] / (10**4), x['总外输气量年累'] / (10**4),
        x['轻油回收量月累'], x['轻油回收量年累'],
        x['丙丁烷回收量月累'], x['丙丁烷回收量年累'],
    ]
    dc = [
        x['天然气月配产'] / (10**4), x['天然气年配产'] / (10**4),
        x['轻油月配产'], x['轻油年配产'],
        x['丙丁烷月配产'], x['丙丁烷年配产'],
    ]
    xx = [
        '天然气月完10km3', '天然气年完万方10km3',
        '轻油月完m3', '轻油年完m3',
        '丙丁烷月完m3', '丙丁烷年完m3',
    ]
    # print(x)
    production = getProductionDataSet(startDate, endDate)
    received = getRecivedDataSet(startDate, endDate)
    output = getOutputDataSet(startDate, endDate)
    consumption = getConsumptionDataSet(startDate, endDate)
    inventory = getInventoryDataSet(startDate, endDate)
    dt = dateList(startDate, endDate)
    xAxis = [d.isoformat() for d in dt]
    legendProduction = list(production.keys())
    legendReceived = list(received.keys())
    legendOutput = list(output.keys())
    legendConsumption = list(consumption.keys())
    legendInventory = list(inventory.keys())
    for x in production:
        production[x] = mend(production[x], dt, 0)
    for x in received:
        received[x] = mend(received[x], dt, 0)
    for x in output:
        output[x] = mend(output[x], dt, 0)
    for x in consumption:
        consumption[x] = mend(consumption[x], dt, 0)
    for x in inventory:
        inventory[x] = mend(inventory[x], dt, 0)
    return render(request, 'ProcessProduction/productionReview.html', locals())

#配产
def proration(request):
    title='配产任务'
    today=date.today()
    data={}
    if request.method == 'POST':
        form = ProrationForm(request.POST)
        if form.is_valid():
            data['天然气月配产'] = form.cleaned_data['天然气月配产']
            data['天然气年配产'] = form.cleaned_data['天然气年配产']
            data['轻油月配产'] = form.cleaned_data['轻油月配产']
            data['轻油年配产'] = form.cleaned_data['轻油年配产']
            data['轻烃月配产'] = form.cleaned_data['轻烃月配产']
            data['轻烃年配产'] = form.cleaned_data['轻烃年配产']
            日期 = form.cleaned_data['日期']
            数据源 = request.user.username+'@'+request.META['REMOTE_ADDR']
            print(data,数据源,request.user.username)
            for k,v in data.items():
                record = 生产信息()
                record.日期 = 日期
                record.名称 = k
                record.单位 = '方'
                record.数据 = v*10000
                record.类别 = k[:-3]
                record.状态 = '计划'
                record.数据源 = 数据源
                record.save()
            s='数据提交成功！'
            return HttpResponse(s)
    else:
        form = ProrationForm()
    return render(request, 'ProcessProduction/proration.html', locals())
#快速录入
def quickInput(request):
    title='快速录入'
    today=date.today()
    if request.method == 'POST':
        form = QuickInputForm(request.POST)
        if form.is_valid():
            data['日期'] = form.cleaned_data['日期']
            data['JZ202体系'] = form.cleaned_data['JZ202体系']
            # print(form.cleaned_data)
            print(data)
            return HttpResponseRedirect('/')
        else:
            form = QuickInputForm()
    return render(request,'ProcessProduction/quickInput.html',locals())