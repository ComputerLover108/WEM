drop index IF EXISTS 生产信息唯一索引;
ALTER TABLE IF EXISTS 生产信息 ALTER 单位 SET DEFAULT '';
ALTER TABLE IF EXISTS 生产信息 ALTER 类别 SET DEFAULT '';
ALTER TABLE IF EXISTS 生产信息 ALTER 状态 SET DEFAULT '';
ALTER TABLE IF EXISTS 生产信息 ALTER 数据源 SET DEFAULT '';

delete from 生产信息 where ID not in ( select max(ID) from 生产信息 group by 日期,名称,单位,类别,状态,备注);  
select * from 生产信息 where 名称 in ('FIQ-5014', 'FIQ-2043', '锅炉房用气', '火炬长明灯', '火炬放空量');

update 生产信息 SET 名称='热油炉' WHERE 名称='锅炉用气';
SELECT 名称,数据
FROM 生产信息
WHERE 日期='2018-9-17'
    AND 名称 IN ('热油炉',
               '锅炉房用气',
               '火炬长明灯',
               '火炬放空量',
               'FIQ-2043')
ORDER BY 名称;


SELECT 名称,sum(数据) AS 月累
FROM 生产信息
WHERE 日期 BETWEEN date_trunc('month',TIMESTAMP '2018-9-17') AND '2018-9-17'
    AND 名称 IN ('热油炉',
               '锅炉房用气',
               '火炬长明灯',
               '火炬放空量',
               'FIQ-2043')
GROUP BY 名称
ORDER BY 名称 ;

SELECT 名称,sum(数据) AS 年累
FROM 生产信息
WHERE 日期 BETWEEN date_trunc('year',TIMESTAMP '2018-9-17') AND '2018-9-17'
    AND 名称 IN ('热油炉',
               '锅炉房用气',
               '火炬长明灯',
               '火炬放空量',
               'FIQ-2043')
GROUP BY 名称
ORDER BY 名称 ;


CREATE UNIQUE INDEX IF NOT EXISTS  生产信息唯一索引  ON 生产信息 (日期,名称,单位,类别,状态,备注);

INSERT INTO 生产信息 (日期,名称,单位,类别,状态,备注,数据源,数据,月累,年累)
VALUES ('2018/9/17',
        '轻油比重',
        '',
        '轻油',
        '',
        '',
        '',
        .725,
        NULL,
        NULL) ON CONFLICT (日期,名称,单位,类别,状态,备注) DO
UPDATE
SET 数据源 = EXCLUDED.数据源,数据 = EXCLUDED.数据,月累 = EXCLUDED.月累,年累 = EXCLUDED.年累
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
SET 数据源 = EXCLUDED.数据源,数据 = EXCLUDED.数据,月累 = EXCLUDED.月累,年累 = EXCLUDED.年累
WHERE 生产信息.数据 IS DISTINCT
    FROM EXCLUDED.数据
    OR 生产信息.月累 IS DISTINCT
    FROM EXCLUDED.月累
    OR 生产信息.年累 IS DISTINCT
    FROM EXCLUDED.年累
    OR 生产信息.数据源 IS DISTINCT
    FROM EXCLUDED.数据源;



