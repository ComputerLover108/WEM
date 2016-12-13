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

    for row in rows:
        if row[0] and row[1] and row[2] and row[3] and row[5] :
            line = [row[0],row[6]+row[1]+row[2],row[3]]
            temp1.append(line)
    # logger.info(temp1)
    names = [x[1] for x in temp1]
    for d in dateList(startDate,endDate):
        nd = dict()
        for x in temp1:
            if x[0] == d :
                nd[x[1]]=x[2] if x[2] else 0
        # nd['轻烃装车方'] = nd['丙烷装车方'] + nd['丁烷装车方'] +nd['液化气装车方']
        data[d] = nd
    return data


