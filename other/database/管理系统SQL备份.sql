-- PostgreSQL pgadmin4 the application server could not be contacted
-- 2018年03月10日 18:15:03 pierian_d 阅读数：2440 标签： PostgreSQL pgadmin4 免安装压缩版  更多
-- 个人分类： 数据库
-- 看到PostgreSQL的使用增长迅猛，又看到文章介绍PostgreSQL比MYSQL少一些坑决定下载一个试用一下，不想安装，下了个postgresql-10.3-1-windows-x64-binaries压缩版。
 -- 然而我不会用，按照PostgreSQL免安装部署方法，然后打开pgAdmin的时候总是报错“The application server could not be contacted.”，尝试了网上的删除c:\Users\your_name\AppData\Roaming\pgAdmin 之内的删除所有文件和文件夹，然后在C:\Program Files\PostgreSQL\10\pgAdmin 4\web 找到config_distro.py文件，添加：MINIFY_HTML=False
-- DATA_DIR = "C:/Data/pgAdmin" # set non-ascii path here，都不行！
 -- 然后找到技术人生上一篇帖子，该作者从官网下载pgAdmin2.0的安装版试了一下，竟然可以正常使用，经过对比发现竟然是只少了1个空文件！
 -- pgAdmin 4/venv/Lib/site-packages/backports/__init__.py
 -- 0字节的空文件，创建一个即可，然后pgAdmin就能正常工作了！
select
  v_d,
  data,
  month,
  year,
  lag(v_d, 1) over (
    order by
      v_d
  ) p1,
  lag(month, 1) over (
    partition by month(v_d)
    order by
      v_d
  ) p2,
  lag(year, 1) over (
    partition by year(v_d)
    order by
      v_d
  ) p3,
  first_value(data) over(
    partition by month(v_d)
    order by
      v_d
  ) p4,
  first_value(month) over(
    partition by month(v_d)
    order by
      v_d
  ) p5,
  first_value(data) over(
    partition by year(v_d)
    order by
      v_d
  ) p6,
  first_value(year) over(
    partition by year(v_d)
    order by
      v_d
  ) p7
from
  tbl;
-- 解释
-- p1  昨天的日期
-- p2  当月统计数据范围内，上一条月累加值
-- p3  当年统计数据范围内，上一条年累加值
-- p4  当月统计数据范围内，第一条月累加值
-- p5  当月统计数据范围内，第一条日值
-- p6  当年统计数据范围内，第一条年累加值
-- p7  当年统计数据范围内，第一条日值

CREATE TABLE IF NOT EXISTS "生产动态" (
  id serial PRIMARY KEY,
  "时间" TIMESTAMP NOT NULL,
  "名称" varchar NOT NULL,
  "单位" varchar DEFAULT '',
  "数据" double PRECISION NOT NULL,
  "类别" varchar DEFAULT '',
  "备注" varchar DEFAULT '',
  UNIQUE (
    时 间,
    名 称,
    单 位
  )
);
DROP INDEX IF EXISTS 生产信息唯一索引;


ALTER TABLE IF EXISTS 生产信息
ALTER 单位
SET DEFAULT '';


ALTER TABLE IF EXISTS 生产信息
ALTER 类别
SET DEFAULT '';


ALTER TABLE IF EXISTS 生产信息
ALTER 状态
SET DEFAULT '';


ALTER TABLE IF EXISTS 生产信息
ALTER 数据源
SET DEFAULT '';


UPDATE 生产信息
SET 单位=''
WHERE 单位 IS NULL;


UPDATE 生产信息
SET 类别=''
WHERE 类别 IS NULL;


UPDATE 生产信息
SET 状态=''
WHERE 状态 IS NULL;


UPDATE 生产信息
SET 备注=''
WHERE 备注 IS NULL;


DELETE
FROM 生产信息
WHERE ID NOT IN
    (SELECT max(ID)
     FROM 生产信息
     GROUP BY 日期,
              名称,
              单位,
              类别,
              状态,
              备注);


SELECT *
FROM 生产信息
WHERE 名称 IN ('FIQ-5014',
             'FIQ-2043',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量');


UPDATE 生产信息
SET 名称='热油炉'
WHERE 名称='锅炉用气';


SELECT 名称,
       数据
FROM 生产信息
WHERE 日期='2018-9-17'
  AND 名称 IN ('热油炉',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量',
             'FIQ-2043')
ORDER BY 名称;

SELECT 名称,
       时间,
       数据,
       lag(时间) OVER (
                     ORDER BY 时间) AS p1,
       lag(数据) over (
                     ORDER BY 时间) as d2,
        数据-lag(数据) over (
                     ORDER BY 时间) as 日累
FROM 生产动态
WHERE 名称 IN ('热油炉',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量',
             'FIQ-2043')
order by 时间 desc,名称
;

SELECT 时间,
	   名称,
       数据-lag(数据) over (
                     ORDER BY 时间) as 日累
FROM 生产动态
WHERE 名称 IN ('热油炉',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量',
             'FIQ-2043')
order by 时间 desc,名称
;

 WITH otb AS
  (SELECT 时间,
          名称,
          单位,
          数据
   FROM 生产动态
   WHERE 名称 IN ('FIQ-5014',
                '锅炉房用气',
                '火炬长明灯',
                '火炬放空量',
                'FIQ-2043')
     AND 时间 <
       (SELECT max(时间)
        FROM 生产动态)),
      ntb AS
  (SELECT 时间,
          名称,
          单位,
          数据
   FROM 生产动态
   WHERE 名称 IN ('FIQ-5014',
                '锅炉房用气',
                '火炬长明灯',
                '火炬放空量',
                'FIQ-2043')
     AND 时间 >
       (SELECT min(时间)
        FROM 生产动态))
SELECT otb.时间,
       ntb.时间,
       otb.名称,
       ntb.数据 - otb.数据 AS 日累
FROM otb,
     ntb
WHERE otb.名称 = ntb.名称
  AND ntb.时间 - otb.时间 = '1 day'
ORDER BY ntb.时间 desc,
         ntb.名称;

 WITH otb AS
  (SELECT 时间,
          名称,
          单位,
          数据
   FROM 生产动态
   WHERE 名称 IN ('FIQ-5014',
                '锅炉房用气',
                '火炬长明灯',
                '火炬放空量',
                'FIQ-2043')
     AND 时间 <
       (SELECT MAX(时间)
        FROM 生产动态)),
      ntb AS
  (SELECT 时间,
          名称,
          单位,
          数据
   FROM 生产动态
   WHERE 名称 IN ('FIQ-5014',
                '锅炉房用气',
                '火炬长明灯',
                '火炬放空量',
                'FIQ-2043')
     AND 时间 >
       (SELECT MIN(时间)
        FROM 生产动态))
SELECT otb.时间 AS t1,
       ntb.时间 AS t2,
       otb.名称 AS name,
       otb.数据 AS d1,
       ntb.数据 AS d2 ,
       ntb.数据 - otb.数据 AS 日累
FROM otb,
     ntb
WHERE otb.名称 = ntb.名称
  AND ntb.时间 - otb.时间 = '1 day'
ORDER BY ntb.名称,ntb.时间 desc
;


SELECT DISTINCT 名称
FROM 生产动态;


SELECT 名称,
       数据
FROM 生产信息
WHERE 日期= date_trunc('month', TIMESTAMP '2018-9-17')
  AND 名称 IN ('热油炉',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量',
             'FIQ-2043')
ORDER BY 名称;


SELECT 名称,
       数据
FROM 生产信息
WHERE 日期= date_trunc('year', TIMESTAMP '2018-9-17')
  AND 名称 IN ('热油炉',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量',
             'FIQ-2043')
ORDER BY 名称;


SELECT 名称,
       sum(数据) AS 月累
FROM 生产信息
WHERE 日期 BETWEEN date_trunc('month',TIMESTAMP '2018-9-17') AND '2018-9-17'
  AND 名称 IN ('热油炉',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量',
             'FIQ-2043')
GROUP BY 名称
ORDER BY 名称 ;


SELECT 名称,
       sum(数据) AS 年累
FROM 生产信息
WHERE 日期 BETWEEN date_trunc('year',TIMESTAMP '2018-9-17') AND '2018-9-17'
  AND 名称 IN ('热油炉',
             '锅炉房用气',
             '火炬长明灯',
             '火炬放空量',
             'FIQ-2043')
GROUP BY 名称
ORDER BY 名称 ;


CREATE UNIQUE INDEX IF NOT EXISTS 生产信息唯一索引 ON 生产信息 (日期,名称,单位,类别,状态,备注);


INSERT INTO 生产信息 (日期,名称,单位,类别,状态,备注,数据源,数据,月累,年累)
VALUES ('2018/9/17', '轻油比重', '', '轻油', '', '', '', .725, NULL,
                                                         NULL) ON CONFLICT (日期,名称,单位,类别,状态,备注) DO
UPDATE
SET 数据源 = EXCLUDED.数据源,
    数据 = EXCLUDED.数据,
    月累 = EXCLUDED.月累,
    年累 = EXCLUDED.年累
WHERE 生产信息.数据 IS DISTINCT
  FROM EXCLUDED.数据
  OR 生产信息.月累 IS DISTINCT
  FROM EXCLUDED.月累
  OR 生产信息.年累 IS DISTINCT
  FROM EXCLUDED.年累
  OR 生产信息.数据源 IS DISTINCT
  FROM EXCLUDED.数据源;


INSERT INTO 生产信息 (日期,名称,单位,类别,状态,备注,数据源,数据,月累,年累)
VALUES ('2018/9/17',
        '污水',
        '方',
        '水',
        '外输',
        '',
        '',
        28,
        NULL,
        NULL) ON CONFLICT (日期,名称,单位,类别,状态,备注) DO
UPDATE
SET 数据源 = EXCLUDED.数据源,
    数据 = EXCLUDED.数据,
    月累 = EXCLUDED.月累,
    年累 = EXCLUDED.年累
WHERE 生产信息.数据 IS DISTINCT
  FROM EXCLUDED.数据
  OR 生产信息.月累 IS DISTINCT
  FROM EXCLUDED.月累
  OR 生产信息.年累 IS DISTINCT
  FROM EXCLUDED.年累
  OR 生产信息.数据源 IS DISTINCT
  FROM EXCLUDED.数据源;