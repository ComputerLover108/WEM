from django.shortcuts import render
import json
from ProcessProduction.views import ProductionDataMonth
from datetime import date
def home(request):
    title="主页"
    图区 = "年度生产统计"
    EchartsTitle = json.dumps("年度生产统计")
    pdate = date.today()
    类目 = json.dumps(pdate.isoformat() + " 产量")
    c = ["天然气(10Km3)","轻油(m3)","轻烃(m3)"]
    d = ProductionDataMonth(pdate)
    d[0] = d[0] / 10000
    categories = json.dumps(c)
    data = json.dumps(d)
    return render(request, "home.html", locals())


