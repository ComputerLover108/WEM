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