import argparse
import pypyodbc
import os
import csv
import codecs
##import timeit
import psycopg2
##import io
##import shutil
##import re
##import chardet
##
##def convertEncoding(filename, target_encoding):
##    # Backup the origin file.
##    shutil.copyfile(filename, filename + '.bak')
##
##    # convert file from the source encoding to target encoding
##    content = codecs.open(filename, 'r').read()
##    source_encoding = chardet.detect(content)['encoding']
##    print(source_encoding, filename)
##    content = content.decode(source_encoding) #.encode(source_encoding)
##    codecs.open(filename, 'w', encoding=target_encoding).write(content)
def CreateTable(tableName):
    connection_string = 'dbname=HLD user=operator password=5302469 host=127.0.0.1 port=2012'
    connection = psycopg2.connect(connection_string)
    cur=connection.cursor()
    if tableName=="生产信息":
        SQL='''CREATE TABLE IF NOT EXISTS "生产信息"
            (
              id serial PRIMARY KEY,
              "日期" date NOT NULL,
              "名称" character varying(16) NOT NULL,
              "单位" character varying(8),
              "数据" double precision,
              "类别" character varying(8),
              "状态" character varying(8),
              "备注" character varying,
              "月累" double precision,
              "年累" double precision
            );
            '''
        cur.execute(SQL)
    if tableName=='生产动态':
        SQL='''CREATE TABLE IF NOT EXISTS "生产动态"
                (
                  id serial PRIMARY KEY,
                  "时间" timestamp with time zone NOT NULL,
                  "名称" character varying(32) NOT NULL,
                  "单位" character varying(32) NOT NULL,
                  "数据" double precision NOT NULL,
                  "类别" character varying(32) NOT NULL,
                  "备注" text
                );
            '''
        cur.execute(SQL)
    if tableName=='提单':
        SQL='''CREATE TABLE IF NOT EXISTS "提单"
                (
                  id serial PRIMARY KEY,
                  "提单号" character varying(16),
                  "日期" date NOT NULL,
                  "产品名称" character varying(32) NOT NULL,
                  "客户名称" character varying(32) NOT NULL,
                  "计划装车t" double precision NOT NULL,
                  "实际装车t" double precision NOT NULL,
                  "实际装车bbl" double precision,
                  "装车数量" integer,
                  "备注" text
                );
            '''
        cur.execute(SQL)
    if tableName=='人员信息':
        SQL='''CREATE TABLE IF NOT EXISTS "人员信息"
                (
                  "身份证号" character varying(32) PRIMARY KEY,
                  "姓名" character varying(32) NOT NULL,
                  "部门" character varying(32) ,
                  "岗位" character varying(32) ,
                  "性别" character varying(8) ,
                  "出生日期" date ,
                  "民族" character varying(32) ,
                  "籍贯" character varying(32) ,
                  "户口所在地" character varying(32) ,
                  "政治面貌" character varying(32) ,
                  "婚姻状况" character varying(32) ,
                  "职称" character varying(32) ,
                  "技能鉴定" character varying(32) ,
                  "家庭地址" character varying(32) ,
                  "联系电话" character varying(32) ,
                  "个人电子邮箱" character varying(75) ,
                  "第一学历" character varying(32) ,
                  "第一学历毕业院校" character varying(32) ,
                  "第一学历专业" character varying(32) ,
                  "第一学历毕业时间" date ,
                  "学历证号" character varying(32) ,
                  "学位证号" character varying(32) ,
                  "最高学历" character varying(32) ,
                  "最高学历毕业院校" character varying(32) ,
                  "最高学历专业" character varying(32) ,
                  "最高学历毕业时间" date ,
                  "最高学历学历证号" character varying(32) ,
                  "最高学历学位证号" character varying(32) ,
                  "参加工作时间" date ,
                  "入党时间" date ,
                  "来海油时间" date ,
                  "外语水平" character varying(32) ,
                  "个人特长" text ,
                  "用工制度" character varying(32) ,
                  "海上工作经历" text ,
                  "备注" text
                );
            '''
        cur.execute(SQL)
    if tableName=='安全阀':
        SQL='''CREATE TABLE IF NOT EXISTS "安全阀"
                (
                    id serial PRIMARY KEY,
                    "区块号" text,
                    "位号" text,
                    "设备号" text,
                    "整定压力" text,
                    "型号" text,
                    "系列号" text,
                    "通径(mm)" text,
                    "连接" text,
                    "磅级" text,
                    "介质" text,
                    "厂家" text,
                    "备注" text,
                    "校验日期" date
                );
            '''
        cur.execute(SQL)
    if tableName=='温度计':
        SQL='''CREATE TABLE IF NOT EXISTS "温度计"
                (
                    id serial PRIMARY KEY,
                    "安装位置" text,
                    "测量范围" text,
                    "生产厂家" text,
                    "出厂编号" text,
                    "规格型号" text,
                    "型式" text,
                    "尾长" text,
                    "尾径" text,
                    "接头" text,
                    "准确度" double precision,
                    "鉴定结果" text,
                    "备注" text
                );
            '''
        cur.execute(SQL)
##    if tableName=='手机号':
##        SQL='''
##            '''
    connection.commit()
    cur.close()
    connection.close()

def CSVtoPostgreSQL(src,tableName,dsn):
##    dsn="dbname=HLD user=operator password=5302469 host=10.30.29.51 port=2012"
    conn = psycopg2.connect(dsn)
    cur=conn.cursor()
    SQL_set="SET client_encoding = 'UTF8';"
    SQL_head=''
    pathName='SQL'
    if not os.path.exists(pathName):
        os.mkdir(pathName)
    fn=os.path.join(pathName,tableName+'.sql')
    temp=open(fn,'w',encoding='utf-8',newline='')
    fileName=os.path.abspath(src)
    f=open(fileName,'r',encoding='utf-8',newline='')
##    temp=io.StringIO(newline='\n')
    ss=f.read()
##    print(ss)
    SQL_filter=''
    if tableName=='生产信息':
        SQL_head='COPY 生产信息 (日期,名称,单位,数据,类别,状态,备注,月累,年累) FROM stdin ;'
        SQL_filter='delete from 生产信息 where id not in (SELECT max(id) FROM 生产信息 GROUP BY 日期,名称,单位,状态,备注);'
    if tableName=='生产动态':
        SQL_head='COPY 生产动态 (时间,名称,单位,数据,类别,备注) FROM stdin ;'
        SQL_filter='delete from 生产动态 where id not in (SELECT max(id) FROM 生产动态 GROUP BY 时间,名称,单位,备注);'
    if tableName=='提单':
        SQL_head='COPY 提单 (提单号,日期,产品名称,客户名称,计划装车t,实际装车t,实际装车bbl,装车数量,备注) from stdin ;'
        SQL_filter='delete from 提单 where id not in (SELECT max(id) FROM 提单 GROUP BY 日期,产品名称,客户名称,计划装车t,实际装车t,备注);'
    if tableName=='安全阀':
        SQL_head='COPY 安全阀 ("区块号" , "位号",  "设备号" ,  "整定压力" ,  "型号" ,  "系列号" , "通径(mm)" ,  "连接" , "磅级" ,  "介质" ,  "厂家" ,  "备注" ,  "校验日期") FROM stdin ;'
        SQL_filter='delete from 安全阀 where id not in (SELECT max(id) FROM 安全阀 GROUP BY 位号);'
    if tableName=='温度计':
        SQL_head='COPY 温度计 (安装位置,测量范围,生产厂家,出厂编号,规格型号,型式,尾长,尾径,接头,准确度,鉴定结果,备注) FROM stdin ;'
        SQL_filter='delete from 温度计 where id not in (SELECT max(id) FROM 温度计 GROUP BY 出厂编号);'
    SQL_end='\\.'
    temp.write(SQL_set)
    temp.write('\n')
    temp.write(SQL_head)
    temp.write('\n')
    temp.write(ss)
    temp.write(SQL_end)
    temp.write('\n')
    temp.write(SQL_filter)
    temp.write('\n')
    f.close()
    temp.close()
    conn.close()
    command='psql -h 127.0.0.1 -p 2012 -U operator -f '+fn+' HLD'
    with os.popen(command) as proc:
        print(proc.read())


def AccessToCSV(infile,pathName,table):
    if not os.path.exists(pathName):
        os.mkdir(pathName)
    outfile=os.path.join(pathName,table) + '.csv'
    con=pypyodbc.win_connect_mdb(infile)
    cur = con.cursor()
    SQL='select * from ' + table + ';'
    if table=='温度计':
        SQL='select 安装位置,测量范围,生产厂家,出厂编号,规格型号,型式,尾长,尾径,接头,准确度,鉴定结果,备注 from 温度计;'
    if table=='安全阀':
        SQL='select "区块号","位号","设备号","整定压力" ,"型号" ,"系列号","通径(mm)","连接","磅级","介质","厂家","备注","校验日期"  from 安全阀;'
    if table=='生产信息':
        SQL='select 日期,名称,单位,数据,类别,状态,备注,月累,年累 from 生产信息;'
    if table=='生产动态':
        SQL="delete from 生产动态 where 名称='';"
        cur.execute(SQL)
        con.commit()
        SQL='select 时间,名称,单位,数据,类别,备注 from 生产动态;'
    if table=='人员信息':
        SQL='select 身份证号,姓名, 部门, 现岗位, 岗位状态, 性别, 出生日期, 民族, 籍贯, 户口所在地, 政治面貌,  婚姻状况, 职称, 技能鉴定, 家庭地址, 联系电话, 个人电子邮箱, 第一学历, 第一学历毕业院校, 第一学历专业, 第一学历毕业时间, 学历证号, 学位证号, 最高学历, 最高学历毕业院校, 最高学历专业, 最高学历毕业时间, 最高学历学历证号, 参加工作时间, 入党时间, 来海油时间, 总工龄, 外语水平, 个人特长, 用工制度,海上工作经历 from 人员信息;'
    if table=='提单':
        SQL='select 提单号,日期,产品名称,客户名称,计划装车t,实际装车t,实际装车bbl,装车数量,备注 from 提单;'
    cur.execute(SQL)
    f=open(outfile,'w',encoding='utf-8',newline='')
    csvfile = csv.writer(f,'excel-tab', quoting=csv.QUOTE_MINIMAL)
##    csvfile = csv.writer(f,'excel-tab', quoting=csv.QUOTE_NONE)
    sSpace='\\N'
    for row in cur.fetchall():
        line=[]
        for i in range(len(row)):
            s=row[i]
            if isinstance(row[i],str):
                if s.find('\r\n') != -1 :
                    s=s.replace('\r\n','\\n')
                if s.find('\n') != -1 :
                    s=s.replace('\n','\\n')
                if s.find('\t') != -1 :
                    s=s.replace('\t','\\t')
            if row[i]==None:
                s=sSpace
            line.append(s)
        csvfile.writerow(line)
##        csvfile.writerow(row)
    f.close()
    con.commit()
    cur.close()
    con.close()


def psqlTest(DSN):
    DSN = "DSN=PostgreSQL35W;Uid=operator;Pwd=5302469;DBname=HLD"
    cnn=pypyodbc.connect(DSN)
    cur=cnn.cursor()
    SQL=''' select * from 生产信息 where 日期='2014-4-1'; '''
    cur.execute(SQL)
##    for d in cur.description:
##        print(d[0])
    for row in cur.fetchall():
        print(row)
    cnn.close()

def AccessTest(src,dsn):
##    src=r'E:\public\test\葫芦岛天然气处理厂管理系统 test\葫芦岛天然气处理厂.mdb'
    if not os.path.exists(src):
##         pypyodbc.win_create_mdb(src)
         print('Access 数据库 ('+src+')没找到!')
         exit(0)
    pathName=r'CSV'
##    tables=['生产信息','生产动态','提单','温度计','安全阀','人员信息']
    tables=['生产信息','生产动态','提单','温度计','安全阀']
    for table in tables:
        CreateTable(table)
        AccessToCSV(src,pathName,table)
        CSVtoPostgreSQL(os.path.join('CSV',table+'.csv'),table,dsn)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-F", "--file",type=str,help="Access file")
    parser.add_argument("-H","--host",type=str,default='127.0.0.1',help="default host is 127.0.0.1")
    parser.add_argument("-P","--port",type=str,default='2012',help="default port is 2012")
    parser.add_argument("-U","--user",type=str,default='operator',help="default user is postgres")
    parser.add_argument("-W","--password",type=str,default='5302469',help="default password is empty!")
    parser.add_argument("-D","--database",type=str,default='HLD',help="default database is postgres")
    args = parser.parse_args()
    if args.file :
        src=args.file
        host=args.host
        port=args.port
        user=args.user
        password=args.password
        dbname=args.database
        dsn='dbname=%s user=%s password=%s host=%s port=%s' %(dbname,user,password,host,port)
        AccessTest(src,dsn)
##    psqlTest()

if __name__ == '__main__':
    main()
