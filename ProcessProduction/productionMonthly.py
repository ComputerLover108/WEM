from django.db import connection
from datetime import date,datetime,timedelta
import re
import logging

logger = logging.getLogger(__name__)

def getProuctionMonthlyData(sd):
	name = [
		'入厂计量',
		'JZ20-2体系',
		'JZ25-1S体系',
		'总外输气量',
		'总产气量',
		'锦天化',
		'精细化工',
		'新奥燃气',
		'自用气',
		'轻油回收量',
		'丙丁烷回收量',
		'水消耗',
		'外供电',
		'电消耗',
		'自发电',	
	]
    cursor = connection.cursor()
    SQL = "select 日期,名称,单位,数据,类别,状态,备注,月累,年累,数据源 from 生产信息 where 日期=%s "
    args = [sd]
    cursor.execute(SQL,args)
    rows = cursor.fetchall()	