from django.shortcuts import render
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from django.db import connection

from .forms import ProrationForm
from ProcessProduce.models import 生产信息,生产动态,提单

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
            gm=生产信息(日期=date,名称='天然气月配产',单位='方',数据=gasM,类别='天然气')          
            gy=生产信息(日期=date,名称='天然气年配产',单位='方',数据=gasY,类别='天然气')
            om=生产信息(日期=date,名称='轻油月配产',单位='方',数据=oilM,类别='轻油')
            oy=生产信息(日期=date,名称='轻油年配产',单位='方',数据=oilY,类别='轻油')
            qtm=生产信息(日期=date,名称='丙丁烷月配产',单位='方',数据=bdM,类别='轻烃')
            qty=生产信息(日期=date,名称='丙丁烷年配产',单位='方',数据=bdY,类别='轻烃')
            bl.append(gm)
            bl.append(gy)
            bl.append(om)
            bl.append(oy)
            bl.append(qtm)
            bl.append(qty)
            生产信息.objects.bulk_create(bl)
            SQL="insert into 生产信息 (名称单位数据)
            SQL="delete from 生产信息 where id not in (select   max(id)   from   生产信息   group   by   日期,名称,单位)"
            with connection.cursor() as c:
                c.execute(SQL)            
            address='ProcessProduce/Proration/{}/'.format(date)
            return HttpResponseRedirect(address)
    else:
        form = ProrationForm()
    return render(request,'ProcessProduce/Proration.html',locals())
    
def RealData(request):
    pass

#报表
def DailyProduction():
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

