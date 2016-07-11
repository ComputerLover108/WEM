-- ALTER TABLE if not exists 生产信息 ADD CONSTRAINT 生产信息免重复 UNIQUE (日期,名称,单位,类别,状态,备注);
alter table if exists 生产信息 alter 单位 set default '';
alter table if exists 生产信息 alter 类别 set default '';
alter table if exists 生产信息 alter 状态 set default '';
alter table if exists 生产信息 alter 备注 set default '';
-- delete from 生产信息 where 名称 in ('V-641A','V-641B','V-642','V-643A','V-643B') and 单位='吨/立方米';
begin;
        insert into 生产信息 (日期,名称,单位,数据,类别) values
        ('2012-1-1','V-641A','吨/立方米',0.52,'丙丁烷'),
        ('2012-1-1','V-641B','吨/立方米',0.52,'丙丁烷'),
        ('2012-1-1','V-642','吨/立方米',0.54,'丙丁烷'),
        ('2012-1-1','V-643A','吨/立方米',0.58,'丙丁烷'),
        ('2012-1-1','V-643B','吨/立方米',0.58,'丙丁烷'),
        ('2016-1-1','V-641A','吨/立方米',0.52,'丙丁烷'),
        ('2016-1-1','V-641B','吨/立方米',0.52,'丙丁烷'),
        ('2016-1-1','V-642','吨/立方米',0.58,'丙丁烷'),
        ('2016-1-1','V-643A','吨/立方米',0.58,'丙丁烷'),
        ('2016-1-1','V-643B','吨/立方米',0.58,'丙丁烷')        
        on conflict (日期,名称,单位,类别,状态,备注) DO UPDATE SET 数据 = EXCLUDED.数据;       
commit;
select * from 生产信息 where 名称 in ('V-641A','V-641B','V-642','V-643A','V-643B') and 单位='吨/立方米' order by 名称,日期;