-- 表结构设计， select , from ,  join, where,  order , limit , sub query, with,

# Index lookup
# Index Range Scan , range查找
# Inner hash join ， join
# Nested loop inner join

show databases;
# Table scan
# where
create table if not exists t
(
    c TINYINT UNSIGNED NOT NULL
);
insert into t
values (1),
       (2),
       (3);
explain analyze
select *
from t
where c << 256;
# | EXPLAIN                                                                                                                                                                            |
#     +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Filter: (0 <> (t.c << 256))  (cost=0.55 rows=3) (actual time=0.027..0.027 rows=0 loops=1)
#     -> Table scan on t  (cost=0.55 rows=3) (actual time=0.020..0.024 rows=3 loops=1)
explain analyze
select *
from t
where c = 1;
# | EXPLAIN                                                                                                                                                                  |
#     +--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Filter: (t.c = 1)  (cost=0.55 rows=1) (actual time=0.020..0.025 rows=1 loops=1)
#     -> Table scan on t  (cost=0.55 rows=3) (actual time=0.019..0.023 rows=3 loops=1)
#     |
#     +--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     1 row in set (0.00 sec)

# range optimization
drop table t;
create table if not exists t
(
    c         TINYINT UNSIGNED NOT NULL,
    key_col_1 int,
    key_col_2 int
);
create index t_key_col_1 on t (key_col_1);
create index t_key_col_2 on t (key_col_2);
insert into t
values (1, 1, 1),
       (2, 2, 2),
       (3, 3, 3);

explain analyze
select *
from t
where key_col_1 > 1;
explain analyze
select *
from t
where key_col_1 > 1
  and key_col_2 < 3;
# | EXPLAIN                                                                                                                                                                                                                                           |
#     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Filter: (t.key_col_2 < 3)  (cost=2.06 rows=3) (actual time=0.025..0.040 rows=2 loops=1)
#     -> Index range scan on t using t_key_col_1, with index condition: (t.key_col_1 > 1)  (cost=2.06 rows=4) (actual time=0.024..0.037 rows=4 loops=1)
#     |
drop index t_key_col_1 on t;
drop index t_key_col_2 on t;
create index t_key_col on t (key_col_1, key_col_2);
explain analyze
select *
from t
where key_col_1 > 1
  and key_col_2 < 3;

# | EXPLAIN                                                                                                                                                                  |
#     +--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Index range scan on t using t_key_col, with index condition: ((t.key_col_1 > 1) and (t.key_col_2 < 3))  (cost=2.06 rows=4) (actual time=0.022..0.029 rows=2 loops=1)

# table scan when or
explain analyze
select *
from t
where key_col_1 > 1
   or key_col_2 < 3;
# | EXPLAIN                                                                                                                                                                                                 |
#     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Filter: ((t.key_col_1 > 1) or (t.key_col_2 < 3))  (cost=0.85 rows=3) (actual time=0.017..0.024 rows=6 loops=1)
#     -> Table scan on t  (cost=0.85 rows=6) (actual time=0.015..0.021 rows=6 loops=1)


# hash join optimization
drop table if exists t1, t2, t3;
create table if not exists t1
(
    c1 int,
    c2 int
);
create table if not exists t2
(
    c1 int,
    c2 int
);
create table if not exists t3
(
    c1 int,
    c2 int
);
insert into t1(c1, c2)
values (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);
insert into t2
select *
from t1;
insert into t3
select *
from t1;
# Inner hash join
explain analyze
select *
from t1
         join t2
where t1.c1 = t2.c1;
# | EXPLAIN                                                                                                                                                                                                                                                                                       |
#     +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Inner hash join (t2.c1 = t1.c1)  (cost=2.50 rows=4) (actual time=0.033..0.035 rows=4 loops=1)
#     -> Table scan on t2  (cost=0.09 rows=4) (actual time=0.003..0.005 rows=4 loops=1)
#     -> Hash
#     -> Table scan on t1  (cost=0.65 rows=4) (actual time=0.016..0.020 rows=4 loops=1)

create index t1_c1 on t1 (c1);
create index t2_c1 on t2 (c1);
create index t3_c1 on t3 (c1);

# Index lookup
explain analyze
select c1
from t1
where c1 = 1;
# | EXPLAIN                                                                                                 |
#     +---------------------------------------------------------------------------------------------------------+
#     | -> Index lookup on t1 using t1_c1 (c1=1)  (cost=0.35 rows=1) (actual time=0.012..0.014 rows=1 loops=1)

# Nested loop inner join
explain analyze
select *
from t1
         join t2
where t1.c1 = t2.c1;
# | EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                            |
#     +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Nested loop inner join  (cost=2.05 rows=4) (actual time=0.064..0.078 rows=4 loops=1)
#     -> Filter: (t1.c1 is not null)  (cost=0.65 rows=4) (actual time=0.049..0.052 rows=4 loops=1)
#     -> Table scan on t1  (cost=0.65 rows=4) (actual time=0.048..0.050 rows=4 loops=1)
#     -> Index lookup on t2 using t2_c1 (c1=t1.c1)  (cost=0.28 rows=1) (actual time=0.005..0.006 rows=1 loops=4)
#     |
explain analyze
select *
from t1
         left join t2 on t1.c1 = t2.c1
where t1.c1 = t2.c1;
# | EXPLAIN                                                                                                                                                                                                                                                                                       |
#     +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Nested loop inner join  (cost=2.05 rows=4) (actual time=0.027..0.040 rows=4 loops=1)
#     -> Table scan on t1  (cost=0.65 rows=4) (actual time=0.015..0.018 rows=4 loops=1)
#     -> Index lookup on t2 using t2_c1 (c1=t1.c1)  (cost=0.28 rows=1) (actual time=0.004..0.005 rows=1 loops=4)


explain analyze
select *
from t1
         join t2 on (t1.c1 = t2.c1 and t1.c2 < t2.c2)
         join t3 on (t2.c1 = t3.c1);
# | EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
#     +-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
#     | -> Nested loop inner join  (cost=2.52 rows=1) (actual time=0.054..0.054 rows=0 loops=1)
#     -> Nested loop inner join  (cost=2.05 rows=1) (actual time=0.053..0.053 rows=0 loops=1)
#     -> Filter: (t1.c1 is not null)  (cost=0.65 rows=4) (actual time=0.019..0.024 rows=4 loops=1)
#     -> Table scan on t1  (cost=0.65 rows=4) (actual time=0.018..0.022 rows=4 loops=1)
#     -> Filter: (t1.c2 < t2.c2)  (cost=0.26 rows=0) (actual time=0.007..0.007 rows=0 loops=4)
#     -> Index lookup on t2 using t2_c1 (c1=t1.c1)  (cost=0.26 rows=1) (actual time=0.005..0.006 rows=1 loops=4)
#     -> Index lookup on t3 using t3_c1 (c1=t1.c1)  (cost=0.33 rows=1) (never executed)
