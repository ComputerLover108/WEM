from django.shortcuts import render
import json
# from ProcessProduction.views import ProductionDataMonth
from ProcessProduction.models import ProductionData
from django.db import connection
from datetime import date
import logging

logger = logging.getLogger(__name__)

def home(request):
    title = "主页"
    EchartsTitle = "生产统计"
    legend = ['天然气', '轻油', '轻烃']
    pdate = date.today()
    cursor = connection.cursor()
    cursor.execute(
        "select distinct 日期 from 生产信息 where 日期 between date_trunc('year',current_date) and current_date order by 日期;")
    rows = cursor.fetchall()
    data = [row[0] for row in rows]
    xAxis = [x.isoformat() for x in data]
    series = dict()
    names = ['锦天化', '轻油回收量', '丙丁烷回收量']
    sdata = list()
    for name in names:
        rows = []
        data = []        
        if name == '锦天化':
            SQL = "select 数据/10000 from 生产信息 where 名称=%s and 单位='方' and 日期 between date_trunc('year',current_date) and current_date order by 日期;"
        else:
            SQL = "select 数据 from 生产信息 where 名称=%s and 单位='方' and 日期 between date_trunc('year',current_date) and current_date order by 日期;"
        cursor.execute(SQL, [name])           
        rows = cursor.fetchall()
        data = [row[0] for row in rows]
        series[name] = data
    # print(series)
    # logger.info(pdate)
    return render(request, "home.html", locals())
