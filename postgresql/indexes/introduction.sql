create table t
(
    a integer,
    b text,
    c boolean
);
insert into t(a, b, c)
select id, chr((32 + random() * 94)::integer), random() < 0.01
from generate_series(1, 100000) as id
order by random();
select attname, correlation
from pg_stats
where tablename = 't';
-- attname | correlation
-- ---------+-------------
--  a       | -0.00285084
--  b       |     0.53016
--  c       |    0.941776
-- correlation绝对值越接近0越好
explain (costs off )
select *
from t
where a = 1;
-- QUERY PLAN
-- -------------------
--  Seq Scan on t
--    Filter: (a = 1)

create index on t (a);
explain (costs off )
select *
from t
where a = 1;
-- QUERY PLAN
-- -------------------------------
--  Index Scan using t_a_idx on t
--    Index Cond: (a = 1)
explain (costs off )
select *
from t
where a <= 100;
-- QUERY PLAN
-- ------------------------------------
--  Bitmap Heap Scan on t
--    Recheck Cond: (a <= 100)
--    ->  Bitmap Index Scan on t_a_idx
--          Index Cond: (a <= 100)
create index on t (b);
explain (costs off )
select *
from t
where a <= 100
  and b = 'a';
-- QUERY PLAN
-- --------------------------------------------------
--  Bitmap Heap Scan on t
--    Recheck Cond: ((a <= 100) AND (b = 'a'::text))
--    ->  BitmapAnd
--          ->  Bitmap Index Scan on t_a_idx
--                Index Cond: (a <= 100)
--          ->  Bitmap Index Scan on t_b_idx
--                Index Cond: (b = 'a'::text)
explain (costs off )
select *
from t
where a <= 40000;
-- QUERY PLAN
-- ------------------------
--  Seq Scan on t
--    Filter: (a <= 40000)
vacuum t;
explain (analyse, costs off)
select a
from t
where a < 100;
-- QUERY PLAN
-- -------------------------------------------------------------------------------
--  Index Only Scan using t_a_idx on t (actual time=0.043..1.089 rows=99 loops=1)
--    Index Cond: (a < 100)
--    Heap Fetches: 0
--  Planning time: 0.098 ms
--  Execution time: 2.256 ms
create index on t (a, b);
explain (costs off )
select *
from t
where a <= 100
  and b = 'a';
-- QUERY PLAN
-- --------------------------------------------------
--  Bitmap Heap Scan on t
--    Recheck Cond: ((a <= 100) AND (b = 'a'::text))
--    ->  BitmapAnd
--          ->  Bitmap Index Scan on t_a_idx
--                Index Cond: (a <= 100)
--          ->  Bitmap Index Scan on t_b_idx
--                Index Cond: (b = 'a'::text)
create index on t (c) where c = true;
explain (costs off )
select *
from t
where c = true;