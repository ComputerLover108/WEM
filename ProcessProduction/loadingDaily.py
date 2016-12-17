from django.db import connection
from datetime import date, datetime, timedelta
import logging

logger = logging.getLogger('django')


def getLoadingData(sd):
    data = dict()
    cursor = connection.cursor()
    SQL = "SELECT 客户名称,产品名称,sum(实际装车t),sum(实际装车bbl)  FROM 提单 WHERE 日期=%s GROUP BY 客户名称,产品名称 ORDER BY 客户名称,产品名称;"
    args = [sd]
    cursor.execute(SQL, args)
    rows = cursor.fetchall()
    names = set()
    names = [row[0] for row in rows]
    logger.info(names)
    for name in names:
        dt = dict()
        temp = list()
        for row in rows:
            if row[0] == name:
                key = row[1] + 't'
                dt[key] = row[2]
                # logger.info(name, key, row[2])
                if row[3]:
                    key = row[1] + 'bbl'
                    dt[key] = row[3]
                    logger.info(name, key, row[3])
        data[name] = dt
        # logger.info(name, dt)
    return data
