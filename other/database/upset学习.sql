begin; 

create table IF NOT EXISTS tbl(  
  c1 int,   
  c2 int,   
  c3 int,   
  c4 int,   
  c5 timestamp,   
  unique (c1,c2)  
); 
insert into tbl   
  select id,id,1,random(),now() from generate_series(1,1000000) t(id)   
  on conflict(c1,c2)   
  do update   
  set   
  c3=excluded.c3,c4=excluded.c4,c5=excluded.c5;  
  
 insert into tbl   
  select id,id,1,random(),now() from generate_series(1,1000000) t(id)   
  on conflict(c1,c2)   
  do update   
  set   
  c3=excluded.c3,c4=excluded.c4,c5=excluded.c5  
  where  
  tbl.c3 is distinct from excluded.c3 or  
  tbl.c4 is distinct from excluded.c4; 
  select * from tb1;  
commit; 