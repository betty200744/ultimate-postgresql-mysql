CREATE OR REPLACE FUNCTION random_text() RETURNS TEXT AS
$$
DECLARE
    possible_chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    output         TEXT := '';
    i              INT4;
    pos            INT4;
BEGIN

    FOR i IN 1..random() * 15
        LOOP
            pos := FLOOR((length(possible_chars) + 1) * random());
            output := output || substr(possible_chars, pos, 1);
        END LOOP;

    RETURN output;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION random_country() RETURNS TEXT AS
$$
DECLARE
    possible_countries TEXT ARRAY DEFAULT ARRAY ['FRANCE', 'GERMANY', 'AUSTRIA', 'ROMANIA', 'HUNGARY', 'SPAIN', 'PORTUGAL', 'ITALY'];
BEGIN

    RETURN possible_countries[FLOOR(random() * array_length(possible_countries, 1)) + 1];
END;
$$ LANGUAGE PLPGSQL;

CREATE TABLE addresses
(
    id      INTEGER     NOT NULL,
    city    VARCHAR(40) NOT NULL,
    country VARCHAR(40) NOT NULL,
    street  VARCHAR(40) NOT NULL
);

CREATE TABLE employees
(
    id         INTEGER NOT NULL,
    company_id INTEGER NOT NULL,
    dep        INTEGER NOT NULL,
    first_name VARCHAR(20),
    last_name  VARCHAR(20),
    salary     INTEGER,
    address_id INTEGER
);

INSERT INTO addresses
SELECT id, random_text() as city, random_country() as country, random_text() as street
from (select generate_series(1, 100000) as id) as id;

INSERT INTO employees
SELECT id,
       FLOOR(random() * 100 + 1)    as company,
       FLOOR(random() * 20 + 1)     as dep,
       random_text()                as last_name,
       random_text()                as first_name,
       FLOOR(random() * 2000)       as salary,
       FLOOR(random() * 100000) + 1 as address_id
FROM (select generate_series(1, 100000) as id) as id;

-- Query 10w rows
explain analyze
select first_name
from employees
where id > 1000
  and id < 10000;
--Seq scan , read data from disk
-- QUERY PLAN
--
-- -----------------------------------------------------------------------------------------
-- --------------------
--  Seq Scan on employees  (cost=0.00..2336.00 rows=9107 width=8) (actual time=0.120..71.144
--  rows=8999 loops=1)
--    Filter: ((id > 1000) AND (id < 10000))
--    Rows Removed by Filter: 91001
--  Planning time: 0.133 ms
--  Execution time: 131.135 ms
alter table employees
    add primary key (id);
vacuum analyze employees;
-- Single-column index
explain analyze
select first_name
from employees
where id > 1000
  and id < 10000;
-- QUERY PLAN
-- cost 变少，Filter变成Index Cond, execution time 变少 ，
-- -----------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using employees_pkey on employees  (cost=0.29..359.53 rows=9012 width=8) (actual time=0.029..65.511 rows=8999 loops=1)
--    Index Cond: ((id > 1000) AND (id < 10000))
--  Planning time: 0.232 ms
--  Execution time: 125.986 ms

EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE company_id = 1
  AND dep = 10
  AND last_name >= 'AF'
  AND last_name < 'B';
-- QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------------
--  Seq Scan on employees  (cost=0.00..2836.00 rows=1 width=8) (actual time=3.800..24.257 rows=3 loops=1)
--    Filter: (((last_name)::text >= 'AF'::text) AND ((last_name)::text < 'B'::text) AND (company_id = 1) AND (dep = 10))
--    Rows Removed by Filter: 99997
--  Planning time: 0.112 ms
--  Execution time: 24.318 ms
create index on employees (company_id, dep, last_name);
vacuum analyze employees;
-- Multi-column Index
EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE company_id = 1
  AND dep = 10
  AND last_name >= 'AF'
  AND last_name < 'B';
-- QUERY PLAN
-- cost 变少， Filter 变成Index Cond,Execution time 大大减少
-- --------------------------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using employees_company_id_dep_last_name_idx on employees  (cost=0.42..8.44 rows=1 width=8) (actual time=0.051..0.095 rows=3 loops=1)
--    Index Cond: ((company_id = 1) AND (dep = 10) AND ((last_name)::text >= 'AF'::text) AND ((last_name)::text < 'B'::text))
--  Planning time: 0.360 ms
--  Execution time: 0.181 ms
-- Partial Index

-- index access predicates
explain analyze
select first_name
from employees
where company_id = 1
  AND dep = 10
  AND last_name >= 'AF'
  AND last_name < 'B';
-- QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using employees_company_id_dep_last_name_idx on employees  (cost=0.42..8.44 rows=1 width=8) (actual time=0.026..0.082 rows=3 loops=1)
--    Index Cond: ((company_id = 1) AND (dep = 10) AND ((last_name)::text >= 'AF'::text) AND ((last_name)::text < 'B'::text))
--  Planning time: 0.145 ms
--  Execution time: 0.167 ms

-- Index Filter Predicates

-- Filter predicates
EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE salary > 200;
-- QUERY PLAN
-- ----------------------------------------------------------------------------------------------------------------
--  Seq Scan on employees  (cost=0.00..2086.00 rows=89933 width=8) (actual time=0.017..591.908 rows=89953 loops=1)
--    Filter: (salary > 200)
--    Rows Removed by Filter: 10047
--  Planning time: 0.107 ms
--  Execution time: 1152.559 ms

-- index only scan
EXPLAIN ANALYZE
SELECT last_name
FROM employees
WHERE company_id = 1
  AND dep = 10
  AND last_name >= 'AF'
  AND last_name < 'B';
-- QUERY PLAN
-- -------------------------------------------------------------------------------------------------------------------------------------------------------
--  Index Only Scan using employees_company_id_dep_last_name_idx on employees  (cost=0.42..4.44 rows=1 width=8) (actual time=0.158..0.199 rows=3 loops=1)
--    Index Cond: ((company_id = 1) AND (dep = 10) AND (last_name >= 'AF'::text) AND (last_name < 'B'::text))
--    Heap Fetches: 0
--  Planning time: 0.126 ms
--  Execution time: 0.269 ms

-- index scan
EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE company_id = 1
  AND dep = 10
  AND last_name >= 'AF'
  AND last_name < 'B';
-- QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------------------------------
--  Index Scan using employees_company_id_dep_last_name_idx on employees  (cost=0.42..8.44 rows=1 width=8) (actual time=0.021..0.057 rows=3 loops=1)
--    Index Cond: ((company_id = 1) AND (dep = 10) AND ((last_name)::text >= 'AF'::text) AND ((last_name)::text < 'B'::text))
--  Planning time: 0.158 ms
--  Execution time: 0.129 ms

-- sequential scan
EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE company_id > 1
  AND company_id < 50;

-- QUERY PLAN
-- ----------------------------------------------------------------------------------------------------------------
--  Seq Scan on employees  (cost=0.00..2336.00 rows=48090 width=8) (actual time=0.012..324.105 rows=48078 loops=1)
--    Filter: ((company_id > 1) AND (company_id < 50))
--    Rows Removed by Filter: 51922
--  Planning time: 0.076 ms
--  Execution time: 625.804 ms

-- bitmap index scan , and
create index on employees (address_id);
vacuum analyze employees;
EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE id < 10000
  AND address_id < 100;
-- QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on employees  (cost=193.57..226.91 rows=9 width=8) (actual time=0.984..1.232 rows=6 loops=1)
--    Recheck Cond: ((address_id < 100) AND (id < 10000))
--    Heap Blocks: exact=6
--    ->  BitmapAnd  (cost=193.57..193.57 rows=9 width=0) (actual time=0.962..0.970 rows=0 loops=1)
--          ->  Bitmap Index Scan on employees_address_id_idx  (cost=0.00..4.99 rows=93 width=0) (actual time=0.017..0.025 rows=88 loops=1)
--                Index Cond: (address_id < 100)
--          ->  Bitmap Index Scan on employees_pkey  (cost=0.00..188.33 rows=10138 width=0) (actual time=0.914..0.921 rows=9999 loops=1)
--                Index Cond: (id < 10000)
--  Planning time: 0.888 ms
--  Execution time: 1.690 ms

-- bitmap index scan , or
EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE id < 10000
   OR address_id < 100;
-- QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on employees  (cost=198.43..1187.89 rows=10221 width=8) (actual time=0.850..69.386 rows=10081 loops=1)
--    Recheck Cond: ((id < 10000) OR (address_id < 100))
--    Heap Blocks: exact=159
--    ->  BitmapOr  (cost=198.43..198.43 rows=10231 width=0) (actual time=0.811..0.816 rows=0 loops=1)
--          ->  Bitmap Index Scan on employees_pkey  (cost=0.00..188.33 rows=10138 width=0) (actual time=0.735..0.740 rows=9999 loops=1)
--                Index Cond: (id < 10000)
--          ->  Bitmap Index Scan on employees_address_id_idx  (cost=0.00..4.99 rows=93 width=0) (actual time=0.016..0.021 rows=88 loops=1)
--                Index Cond: (address_id < 100)
--  Planning time: 0.098 ms
--  Execution time: 135.150 ms

-- bitmap index scan , or
EXPLAIN ANALYZE
SELECT first_name
FROM employees
WHERE id = 1
   or id = 2;
-- QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on employees  (cost=8.60..16.34 rows=2 width=8) (actual time=0.082..0.112 rows=2 loops=1)
--    Recheck Cond: ((id = 1) OR (id = 2))
--    Heap Blocks: exact=1
--    ->  BitmapOr  (cost=8.60..8.60 rows=2 width=0) (actual time=0.058..0.068 rows=0 loops=1)
--          ->  Bitmap Index Scan on employees_pkey  (cost=0.00..4.30 rows=1 width=0) (actual time=0.021..0.030 rows=1 loops=1)
--                Index Cond: (id = 1)
--          ->  Bitmap Index Scan on employees_pkey  (cost=0.00..4.30 rows=1 width=0) (actual time=0.009..0.019 rows=1 loops=1)
--                Index Cond: (id = 2)
--  Planning time: 0.087 ms
--  Execution time: 0.667 ms

-- Nested Loops Join

vacuum analyze employees;
explain analyze
select *
from employees as e
         join addresses a on a.id = e.address_id;
-- QUERY PLAN
-- -----------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=0.29..41.22 rows=100 width=63) (actual time=0.075..8.123 rows=100 loops=1)
--    ->  Nested Loop  (cost=0.29..40929.00 rows=100000 width=63) (actual time=0.060..6.530 rows=100 loops=1)
--          ->  Seq Scan on addresses a  (cost=0.00..1731.00 rows=100000 width=27) (actual time=0.023..0.880 rows=111 loops=1)
--          ->  Index Scan using employees_address_id_idx on employees e  (cost=0.29..0.37 rows=2 width=36) (actual time=0.011..0.019 rows=1 loops=111)
--                Index Cond: (address_id = a.id)
--  Planning time: 0.320 ms
--  Execution time: 8.974 ms

-- Hash Join , 没有命中index时， 或者无limit，全表join时

-- QUERY PLAN
-- ---------------------------------------------------------------------------------------------------------------------------------
--  Hash Join  (cost=3665.00..9124.00 rows=100000 width=63) (actual time=1301.988..3266.872 rows=100000 loops=1)
--    Hash Cond: (e.address_id = a.id)
--    ->  Seq Scan on employees e  (cost=0.00..1836.00 rows=100000 width=36) (actual time=0.008..626.978 rows=100000 loops=1)
--    ->  Hash  (cost=1731.00..1731.00 rows=100000 width=27) (actual time=1301.869..1301.874 rows=100000 loops=1)
--          Buckets: 65536  Batches: 2  Memory Usage: 3443kB
--          ->  Seq Scan on addresses a  (cost=0.00..1731.00 rows=100000 width=27) (actual time=0.014..636.888 rows=100000 loops=1)
--  Planning time: 0.207 ms
--  Execution time: 3878.451 ms

-- Merge join
explain analyze
select *
from employees as e
         join addresses a on a.id = e.address_id
order by a.id
limit 100;
-- QUERY PLAN
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Limit  (cost=12430.16..12438.11 rows=100 width=67) (actual time=1313.775..1320.255 rows=100 loops=1)
--    ->  Merge Join  (cost=12430.16..20378.04 rows=100000 width=67) (actual time=1313.758..1318.888 rows=100 loops=1)
--          Merge Cond: (e.address_id = a.id)
--          ->  Index Scan using employees_address_id_idx on employees e  (cost=0.29..5948.29 rows=100000 width=36) (actual time=0.018..0.731 rows=100 loops=1)
--          ->  Materialize  (cost=12429.82..12929.82 rows=100000 width=27) (actual time=1313.711..1315.867 rows=145 loops=1)
--                ->  Sort  (cost=12429.82..12679.82 rows=100000 width=27) (actual time=1313.693..1314.363 rows=112 loops=1)
--                      Sort Key: a.id
--                      Sort Method: external sort  Disk: 3712kB
--                      ->  Seq Scan on addresses a  (cost=0.00..1731.00 rows=100000 width=27) (actual time=0.018..628.209 rows=100000 loops=1)
--  Planning time: 0.240 ms
--  Execution time: 1321.766 ms

alter table addresses
    add primary key (id);
vacuum analyze addresses;
explain analyze
select *
from employees as e
         join addresses a on a.id = e.address_id
order by a.id;
-- QUERY PLAN
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Merge Join  (cost=0.73..10786.58 rows=100000 width=67) (actual time=0.065..3303.696 rows=100000 loops=1)
--    Merge Cond: (e.address_id = a.id)
--    ->  Index Scan using employees_address_id_idx on employees e  (cost=0.29..5948.29 rows=100000 width=36) (actual time=0.017..731.473 rows=100000 loops=1)
--    ->  Index Scan using addresses_pkey on addresses a  (cost=0.29..3338.29 rows=100000 width=27) (actual time=0.015..651.614 rows=100000 loops=1)
--  Planning time: 0.546 ms
--  Execution time: 3923.444 ms