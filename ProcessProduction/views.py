from django.shortcuts import render
from django.http import HttpResponse, JsonResponse, HttpResponseRedirect
from django.db.models import Q
from datetime import date, datetime, time
from django.contrib.auth.decorators import permission_required, login_required
from django.views.generic import ListView
from django.db.models import Q
from django.db import connection

from .productionData import *
from .models import ProductionData, ProductionStatus, LadingBill
from .productionDaily import *
from .productionMonthly import *
from .loadingDaily import *
from .assay import dataMining

from .forms import QuickInputForm, ProrationForm
from django.conf import settings
import json

from pypinyin import pinyin, lazy_pinyin
import os
# Create your views here.
import logging
# logger = logging.getLogger(__name__)
logger = logging.getLogger('django')

def getDataSource():
    if request.META.has_key('HTTP_X_FORWARDED_FOR'):  
        ip =  request.META['HTTP_X_FORWARDED_FOR']  
    else:  
        ip = request.META['REMOTE_ADDR']
    user=request.user.username
    return user+'@'+ip

def index(request):
    title = '工艺生产'
    用户 = '游客'
    数据采集 = (
        ('配产数据', 'Proration'),
        ('快速录入', 'QuickInput'),
        ('装车数据', 'LadingBillForm'),
        ('海管数据', 'SeaPipeData'),
        ('化验数据', 'assay/getLaboratoryDaily'),
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
    model = ProductionData
    fields = ['日期', '名称', '单位', '数据', '类别', '状态', '备注', '月累', '年累']
    context_object_name = 'ProductionDataList'
    paginate_by = 16

    def get_queryset(self):
        queryset = ProductionData.objects.all().order_by(
            '-日期', '状态', '类别', '单位', '名称', '备注')
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
    model = ProductionStatus
    context_object_name = 'ProductionStatusList'
    paginate_by = 16

    def get_queryset(self):
        queryset = ProductionStatus.objects.all().order_by('-时间', '类别', '名称', '单位', '备注')
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
@login_required(login_url='/Account/login')
def ladingBillForm(request):
    if request.user.username != '工艺':
        return HttpResponse('请使用工艺账户登录！')
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


@login_required(login_url='/Account/login')
def SeaPipeData(request):
    if request.user.username != '工艺':
        return HttpResponse('请使用工艺账户登录！')
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
    if request.method == 'POST':
        print('POST OK!')
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

# 配产


@login_required(login_url='/Account/login')
def proration(request):
    if request.user.username != '工艺':
        return HttpResponse('请使用工艺账户登录！')
    title = '配产任务'
    today = date.today()
    data = {}
    if request.method == 'POST':
        form = ProrationForm(request.POST)
        if form.is_valid():
            data['天然气月配产'] = form.cleaned_data['天然气月配产']
            data['天然气年配产'] = form.cleaned_data['天然气年配产']
            data['轻油月配产'] = form.cleaned_data['轻油月配产']
            data['轻油年配产'] = form.cleaned_data['轻油年配产']
            data['丙丁烷月配产'] = form.cleaned_data['丙丁烷月配产']
            data['丙丁烷年配产'] = form.cleaned_data['丙丁烷年配产']
            日期 = form.cleaned_data['日期']
            数据源 = request.user.username + '@' + request.META['REMOTE_ADDR']
            单位 = '方'
            状态 = '计划'
            with connection.cursor() as cursor:
                cursor.execute("update 生产信息 set 备注='' where 备注 is null;")
                cursor.execute(
                    "delete from 生产信息 where 日期=%r and 状态=%r ;", [日期, 状态])
            for k, v in data.items():
                名称 = k
                数据 = v * 10000
                类别 = k[:-3]
                with connection.cursor() as cursor:
                    cursor.execute("insert into 生产信息 (日期,名称,单位,数据,类别,状态,数据源) values (%r,%r,%r,%r,%r,%r,%r)", [
                                   日期, 名称, 单位, 数据, 类别, 状态, 数据源])
                # record = 生产信息(日期=日期, 名称=k, 单位='方', 数据=v * 10000, 类别=k[:-3], 状态='计划', 数据源=数据源)
                # record.save()
            s = '数据提交成功！'
            return HttpResponse(s)
    else:
        form = ProrationForm()
    return render(request, 'ProcessProduction/proration.html', locals())
# 快速录入


@login_required(login_url='/Account/login')
def quickInput(request):
    if request.user.username != '工艺':
        return HttpResponse('请使用工艺账户登录！')
    title = '快速录入'
    today = date.today()
    if request.method == 'POST':
        form = QuickInputForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            print(data)
            return HttpResponseRedirect('ProcessProduction/ProductionDaily')
        else:
            print(form.errors.as_data())
            form = QuickInputForm()
    return render(request, 'ProcessProduction/quickInput.html', locals())

@login_required(login_url='/Account/login')
def getLaboratoryDaily(request):
    Title='化验日报'
    # if request.META.has_key('HTTP_X_FORWARDED_FOR'):  
    #     ip =  request.META['HTTP_X_FORWARDED_FOR']  
    # else:  
    #     ip = request.META['REMOTE_ADDR']
    # user=request.user.username   
    source = request.user.username+'@'+request.META['REMOTE_ADDR']
    # logger.info(source)
    location = os.path.join(settings.MEDIA_ROOT,'化验日报')
    if not os.path.exists(location):
        os.mkdir(location)
    if request.method == "POST":    # 请求方法为POST时，进行处理
        myFile =request.FILES.get("myfile", None)    # 获取上传的文件，如果没有文件，则默认为None
        if not myFile:
            return HttpResponse("请重新提交!")
        # destination = open(os.path.join(location,myFile.name),'wb+')    # 打开特定的文件进行二进制的写操作
        # for chunk in myFile.chunks():      # 分块写入文件
        #     destination.write(chunk)
        # destination.close()
        absFileName = os.path.join(location, myFile.name)
        with open(absFileName,'wb') as destination:
            for chunk in myFile.chunks():
                destination.write(chunk)
        logger.info(absFileName)
        data=dataMining(absFileName)
        for k in data.keys():
            if not data[k]:
                continue
            if k == '日期':
                continue
            if re.match('未凝.*',str(data[k])):
                value=data[k][2:] 
            else:
                value=data[k]
            name=unit=category=remark=None           
            if re.match('.*乙二醇.*',k):
                category='乙二醇' 
            if k=='乙二醇日回收量m3':
                name='乙二醇日回收量'
                value=data[k]
                category='乙二醇'
                unit='方'
                if ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category).exists():
                    ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category).update(数据=value,数据源=source)
                else:
                    p=ProductionData.objects.create(日期=data['日期'],名称=name,单位=unit,数据=value,类别=category,数据源=source)
                    p.save()
                continue               
            if re.match('轻油',k):
                if k=='轻油外输凝点℃':
                    name='外输凝点'
                    unit='摄氏度'
                if k=='轻油饱和蒸汽压KPa':
                    name ='饱和蒸汽压'
                    unit = '千帕'
                if k=='轻油稳定塔顶压力MPa':
                    name ='轻油稳定塔顶压力'
                    unit = '兆帕'
                if k=='轻油稳定塔底操作温度℃':
                    name = '轻油稳定塔底操作温度'
                    unit = '摄氏度'
                if re.match('.*PH值',k):
                    name=re.sub('轻油','',k)
                    logger.info('%r,%r',k,name)
                # value=data[k]
                category='轻油'
                logger.info('%r,%r,%r,%r,%r,%r',data['日期'],name,unit,value,category,remark)
                if ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).exists():
                    ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).update(数据=value,数据源=source)
                else:
                    p=ProductionData.objects.create(日期=data['日期'],名称=name,单位=unit,数据=value,类别=category,备注=remark,数据源=source)
                    p.save()
                continue                               
            if re.match('[上,下]午.*',k) :
                name = k[2:]
                remark = k[:2]
                if re.match('.*轻油.*',k):
                    name=re.sub('轻油','',name)
                    category = '轻油'
                if re.match('.*海管.*',k):
                    category='海管'
                if re.match('.*凝点',k):
                    unit='摄氏度'               
                if ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).exists():
                    ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).update(数据=value,数据源=source)
                else:
                    p=ProductionData.objects.create(日期=data['日期'],名称=name,单位=unit,数据=value,类别=category,备注=remark,数据源=source)
                    p.save()
                logger.info('%r,%r,%r,%r,%r,%r',data['日期'],name,unit,value,category,remark)
                continue 
            # if re.match('V631',k):
            #     name = k
            #     value = data[k]
            #     if re.match('饱和蒸气压',k):
            #         unit = '千帕'
            #     if re.match('密度',k):
            #         unit = '千克/立方米'
            #     if re.match('含水',k):
            #         unit = None
            #     category = '轻油'
            #     remark = None
            #     if ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).exists():
            #         ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).update(数据=value)
            #     else:
            #         p=ProductionData.objects.create(日期=data['日期'],名称=name,单位=unit,数据=value,类别=category,备注=remark)
            #         p.save()
            #     logger.info('%r,%r,%r,%r,%r,%r',data['日期'],name,unit,value,category,remark)                
        if data['V631A密度'] or data['V631B密度'] or data['V631C密度']:
            name = '轻油密度'
            value = max(data['V631A密度'],data['V631B密度'],data['V631C密度'])
            unit = '千克/立方米'
            category = '轻油'
            remark = None
            if ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).exists():
                ProductionData.objects.filter(日期=data['日期'],名称=name,单位=unit,类别=category,备注=remark).update(数据=value,数据源=source)
            else:
                p=ProductionData.objects.create(日期=data['日期'],名称=name,单位=unit,数据=value,类别=category,备注=remark,数据源=source)
                p.save()
            logger.info('%r,%r,%r,%r,%r,%r',data['日期'],name,unit,value,category,remark)


        return render(request, 'ProcessProduction/getLaboratoryDaily.html', locals())
    return render(request, 'ProcessProduction/getLaboratoryDaily.html', locals())