# 数据存在memory, 重启mysql数据就没了
use employees;
show engines ;
drop table  t1_mem;
create table t1_mem(id int, name char(20)) engine memory;
show create table t1_mem;
insert into t1_mem(id, name) VALUES (1, 'a'), (2, 'b');
select * from t1_mem;
# after service mysql restart