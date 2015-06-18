from django.shortcuts import render
import operator
# Create your views here.
def index(request):
    title='工艺生产'
    用户='游客'
##    背景图片='/static/images/工艺生产.jpg'
    buttons=(
        ('快速录入','QuickInput'),
        ('海管状态','SeaPipeStatus'),
        ('装车信息','OutputReport'),
        ('化验报表','TestData'),
        ('生产日报','Daily'),
        ('生产月报','MonthlyReport'),
        ('生产年报','AnnualReport'),
        ('生产动态','ProductionStatus'),
    )
    return render(request, 'ProcessProduce/index.html', locals())

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