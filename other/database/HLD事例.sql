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


CREATE UNIQUE INDEX IF NOT EXISTS  生产信息唯一索引  ON 生产信息 (日期,名称,单位,类别,状态,备注); 
INSERT INTO 生产信息 (日期,名称,单位,数据,备注)
    VALUES (5, 'Gizmo Transglobal') 
    ON CONFLICT (生产信息唯一索引) DO UPDATE SET 数据 = EXCLUDED.数据 where  生产信息.数据 is distinct from EXCLUDED.数据;
"INSERT INTO 生产信息 ( 日期,名称,单位,数据,类别) VALUES ( '2018/9/17','FIQ-5014日累','方','0','天然气') ON CONFLICT (生产信息唯一索引) DO UPDATE SET 数据 = EXCLUDED.数据 where  生产信息.数据 is distinct from EXCLUDED.数据;"    
INSERT INTO 生产信息 ( 日期,名称,单位,数据,类别,状态,备注,数据源,月累,年累) VALUES ( '2018/9/17','轻油比重','',.725,'轻油','','','',,) ON CONFLICT (生产信息唯一索引) DO UPDATE SET 数据 = EXCLUDED.数据 where  生产信息.数据 is distinct from EXCLUDED.数据;
-2147467259   错误: 语法错误 在 "," 或附近的;
Error while executing the query           INSERT INTO 生产信息 ( 日期,名称,单位,数据,类别,状态,备注,数据源,月累,年累) VALUES ( '2018/9/17','轻油比重','',.725,'轻油','','','',,) ON CONFLICT (生产信息唯一索引) DO UPDATE SET 数据 = EXCLUDED.数据 where  生产信息.数据 is distinct from EXCLUDED.数据;
 0 
-2147467259 错误: 字段 "生产信息唯一索引" 不存在;
Error while executing the query
0   
20  无错误恢复


