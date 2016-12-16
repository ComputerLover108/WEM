from django.db import connection
from datetime import date, datetime, timedelta
import logging

logger = logging.getLogger('django')


def getLoadingData(sd):
    data = dict()
    dt = dict()
    dbbl = dict()
    cursor = connection.cursor()
    SQL = "SELECT 客户名称,产品名称,sum(实际装车t),sum(实际装车bbl)  FROM 提单 WHERE 日期=%s GROUP BY 客户名称,产品名称 ORDER BY 客户名称,产品名称;"
    args = [sd]
    cursor.execute(SQL, args)
    rows = cursor.fetchall()
    for row in rows:
        key = row[0]
        dt[row[1]] = row[2]
        dbbl[row[1]] = row[3]
        data[key] = dt
        logger.info(key, dt, dbbl)
    return data
