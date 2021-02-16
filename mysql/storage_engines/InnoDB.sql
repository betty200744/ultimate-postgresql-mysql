
# transaction, row-level lock, foreign keys
# InnoDB, Recovery
# InnoDB, Buffer pool to caches table and index
# Foreign keys
# Auto Optimized,
# Adaptive Hash Index

# Best practices


use employees;
drop table  t1_mem;
create table t1_mem(id int, name char(20)) engine memory;
show create table t1_mem;
insert into t1_mem(id, name) VALUES (1, 'a'), (2, 'b');
select * from t1_mem;