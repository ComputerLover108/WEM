from django.db import connection
from datetime import date, datetime, timedelta
from .models import LadingBill
import logging

logger = logging.getLogger('django')


def getSimpleLoadingData(sd, data):
    names = ['丙烷', '丁烷', '液化气', '轻油']
    # names = LadingBill.objects.distinct('产品名称')
    # logger.info('%r',names)
    data = dict()
    cursor = connection.cursor()
    SQL = "SELECT 日期,产品名称,sum(实际装车m3),sum(实际装车bbl),sum(实际装车t) FROM 提单 WHERE 日期=%s GROUP BY 日期,产品名称;"
    args = [sd]
    cursor.execute(SQL, args)
    rows = cursor.fetchall()
    if not rows:
        return False
    # logger.info('%r', rows)
    for row in rows:
        for name in names:
            if name == row[1]:
                if row[2]:
                    ns = name + '装车方'
                    data[ns] = row[2]
                if row[3]:
                    ns = name + '装车桶'
                    data[ns] = row[3]
                if row[4]:
                    ns = name + '装车吨'
                    data[ns] = row[4]
    # logger.info('%r', data)
    return True


def getLoadingData(sd):
    data = dict()
    cursor = connection.cursor()
    SQL = "SELECT 客户名称,产品名称,sum(实际装车t),sum(实际装车bbl)  FROM 提单 WHERE 日期=%s GROUP BY 客户名称,产品名称 ORDER BY 客户名称,产品名称;"
    args = [sd]
    cursor.execute(SQL, args)
    rows = cursor.fetchall()
    logger.info('%r:%r', sd, rows)
    names = set()
    names = [row[0] for row in rows]
    # logger.info(names)
    for name in names:
        dt = dict()
        for row in rows:
            if row[0] == name:
                key = row[1] + 't'
                dt[key] = row[2]
                if row[3]:
                    key = row[1] + 'bbl'
                    dt[key] = row[3]
                    # logger.info(name, key, row[3])
        data[name] = dt

    records = []
    keys = sorted(data.keys())
    for k in keys:
        record = [None] * 6
        record[0] = k
        v = data[k]
        if '丙烷t' in v:
            record[1] = v['丙烷t']
        if '丁烷t' in v:
            record[2] = v['丁烷t']
        if '液化气t' in v:
            record[3] = v['液化气t']
        if '轻油t' in v:
            record[4] = v['轻油t']
        if '轻油bbl' in v:
            record[5] = v['轻油bbl']
        records.append(record)

    rowLimit = 20
    if len(records) < rowLimit:
        records += [[None] * 6] * (rowLimit - len(records))
    # 添加合计，月累，年累
    times = ['day', 'month', 'year']
    for time in times:
        dt = {}
        SQL = "SELECT 产品名称,sum(实际装车t),sum(实际装车bbl) FROM 提单 WHERE 日期 BETWEEN date_trunc(%s,TIMESTAMP %s) AND %s group by 产品名称;"
        args = [time, sd, sd]
        cursor.execute(SQL, args)
        rows = cursor.fetchall()
        for row in rows:
            key = row[0] + 't'
            dt[key] = round(row[1], 2)
            if row[2]:
                key = row[0] + 'bbl'
                dt[key] = round(row[2], 4)
        if time == 'day':
            data['日累'] = dt
        if time == 'month':
            data['月累'] = dt
        if time == 'year':
            data['年累'] = dt

    names = ['日累', '月累', '年累']
    for k in names:
        record = [None] * 6
        record[0] = k
        v = data[k]
        if '丙烷t' in v:
            record[1] = v['丙烷t']
        if '丁烷t' in v:
            record[2] = v['丁烷t']
        if '液化气t' in v:
            record[3] = v['液化气t']
        if '轻油t' in v:
            record[4] = v['轻油t']
        if '轻油bbl' in v:
            record[5] = v['轻油bbl']
        records.append(record)

    logger.info('%r', records)
    return records
