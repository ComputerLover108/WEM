from django.db import connection
from datetime import date,datetime,timedelta
import re

from .productionData import *
import logging

# logger = logging.getLogger(__name__)
logger = logging.getLogger('django')
def getProductionMonthlyData(sd):
    de = datetime.strptime(sd,"%Y-%m-%d")
    endDate = date(de.year,de.month,de.day)
    startDate = date(endDate.year,endDate.month,1)
    data = dict()

    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据,类别,状态,备注 from 生产信息 where 日期 between %s and %s;"
    args = [startDate,endDate]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()
    temp1 = list()
    names = set()
    value = dict()
    for row in rows:
        if row[0] and row[1] and row[2] and row[3] and row[5] :
            name = row[6]+row[1]+row[2]
            line = [row[0],name,row[3]]
            names.add(name)
            temp1.append(line)

    # names.add('精细化工CNG方')
    # names.add('污水处理厂方')
    # names.add('自采水方')
    # names = sorted(names)
    # logger.info(names)
    for d in dateList(startDate,endDate):
        nd = dict()
        for x in temp1:
            if x[0] == d :
                nd[x[1]]=x[2] 
        data[d] = nd
    for k,v in data.items():
        for name in names:
            if not name in v:
                v[name]=0
    for v in data.values():
        if ('丙烷装车方' in v) and ('丁烷装车方' in v) and  ('液化气装车方' in v):
            v['轻烃装车方'] = v['丙烷装车方'] + v['丁烷装车方'] +v['液化气装车方'] 
    return data


