-- 轻油月库存
select 日期,sum(数据) from 生产信息 where 
    日期 between date_trunc('month',current_date) and current_date
    and 名称 in ('V-631A','V-631B','V-631C')
    and 单位='方'
    and 类别='轻油'
    and 状态='库存'
    group by 日期 order by 日期
 ;

 -- 丙烷月库存
 select 日期,sum(数据) from 生产信息 where 
    日期 between date_trunc('month',current_date) and current_date
    and 单位='方'
    and 类别='丙丁烷'
    and 状态='库存'
    and 备注='丙烷'
    group by 日期 order by 日期
 ;
 -- 丁烷月库存
select 日期,sum(数据) from 生产信息 where 
    日期 between date_trunc('month',current_date) and current_date
    and 单位='方'
    and 类别='丙丁烷'
    and 状态='库存'
    and 备注='丁烷'
    group by 日期 order by 日期
 ;
 -- 液化气月库存
 select 日期,sum(数据) from 生产信息 where 
    日期 between date_trunc('month',current_date) and current_date
    and 单位='方'
    and 类别='丙丁烷'
    and 状态='库存'
    and 备注='液化气'
    group by 日期 order by 日期
 ;
 -- 轻烃月库存
 select 日期,sum(数据) from 生产信息 where 
    日期 between date_trunc('month',current_date) and current_date
    and 名称 in ('V-641A','V-641B','V-642','V-643A','V-643B')
    and 单位='方'
    and 类别='丙丁烷'
    and 状态='库存'
    group by 日期 order by 日期
 ;
 -- 乙二醇库存（包含死库存)
 select 日期,sum(数据) from 生产信息 where 
    日期 between date_trunc('month',current_date) and current_date
    and 名称 in ('乙二醇库存','乙二醇死库存')
    and 单位='方'
    and 类别='化学药剂'
    and 状态='库存'
    group by 日期 order by 日期
 ;
 -- 水库存
 select 日期,sum(数据) from 生产信息 where 
    日期 between date_trunc('month',current_date) and current_date
    and 单位='方'
    and 类别='水'
    and 状态='库存'
    group by 日期 order by 日期
 ;


CREATE UNIQUE INDEX IF NOT EXISTS 生产信息唯一索引 ON 生产信息 (日期,名称,单位,类别,状态,备注);

INSERT INTO 生产信息 (日期,名称,单位,数据,备注)
VALUES (5,
        'Gizmo Transglobal') ON CONFLICT (生产信息唯一索引) DO
UPDATE
SET 数据 = EXCLUDED.数据
where 生产信息.数据 is distinct
   from EXCLUDED.数据;


SELECT CONCAT(名称,单位),
       SUM(数据)/POWER(10,4) AS 年累万方
FROM 生产信息
WHERE 日期 BETWEEN DATE_TRUNC('YEAR',TIMESTAMP '2019-3-31') AND '2019-3-31'
   AND 单位='方'
   AND 名称 IN ('总外输气量',
              '自用气',
              '火炬放空量',
              '火炬长明灯')
GROUP BY 名称,单位;

SELECT 名称,单位,数据,年累,状态  FROM 生产信息 
   WHERE 日期='2019-3-31' 
   AND 备注='盘库' ORDER BY 名称,状态;

SELECT concat(名称,单位),SUM(数据) as 年累吨 FROM 生产信息 
   WHERE 日期 BETWEEN date_trunc('year',timestamp '2019-3-31') AND '2019-3-31' 
   AND 单位='吨'
   AND 名称 IN ('轻油装车','丙烷装车','丁烷装车','液化气装车')
   GROUP BY 名称,单位;

SELECT 名称,单位,数据 FROM 生产信息
   WHERE 日期='2019-3-31'
   AND 状态='库存'
   AND 类别 IN ('轻油','轻烃');

SELECT concat(名称,单位) as name,数据 FROM 生产信息
   WHERE 日期='2019-3-31'
   AND 状态='库存' AND 名称 ~('轻油|轻烃') AND 单位='吨'
   ORDER BY name;

SELECT concat('年累',状态,名称,单位) as name,年累 FROM 生产信息
   WHERE 日期='2019-4-30'
   AND 状态='外输' AND 备注='盘库'
   ORDER BY name;

BEGIN;
CREATE TABLE IF NOT EXISTS "ProductionInformation" (
   "ID"  SERIAL PRIMARY KEY,
   "Date"   DATE NOT NULL,
   "Name"   VARCHAR(32) NOT NULL,
   "Unit"   VARCHAR(32) DEFAULT '',
   "Data"   DOUBLE PRECISION NOT NULL,
   "Category"  VARCHAR(32) DEFAULT '',
   "Status" VARCHAR(32) DEFAULT '',
   "Remark" VARCHAR  DEFAULT '',
   "MonthSum"  DOUBLE PRECISION ,
   "YearSum"   DOUBLE PRECISION,
   "DataSource"   VARCHAR DEFAULT ''
);
CREATE UNIQUE INDEX IF NOT EXISTS "ProductionInformationUnique" 
   ON "ProductionInformation" (
      "Date","Name","Unit","Status","Remark"
   );

CREATE TABLE IF NOT EXISTS "ProductionStatus" (
   "ID"  SERIAL PRIMARY KEY,
   "Time"   TIMESTAMP NOT NULL,
   "Name"   VARCHAR(32) NOT NULL,
   "Unit"   VARCHAR(32) DEFAULT '',
   "Data"   DOUBLE PRECISION NOT NULL,
   "Category"  VARCHAR(32) DEFAULT '',
   "Remark" VARCHAR  DEFAULT ''
);
CREATE UNIQUE INDEX IF NOT EXISTS "ProductionStatusUnique"
   ON "ProductionStatus" (
      "Time","Name","Unit"
   );
COMMIT;