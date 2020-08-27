#
drop table if exists t1, t2, t3;
create table if not exists t1
(
    c1 int primary key,
    c2 int
);
create table if not exists t2
(
    c1 int primary key,
    c2 int
);
create table if not exists t3
(
    c1 int primary key,
    c2 int
);
insert into t1(c1, c2)
values (1, 1),
       (2, 2),
       (3, 3),
       (4, 4);
select *
from t1;

insert into t2(c1, c2)
values (1, 1),
       (4, 4),
       (5, 5),
       (6, 6);;

insert into t3
select *
from t1;

## inner join 同full join 带on
select *
from t1
         inner join t2 on t1.c1 = t2.c1;


## join 同inner join
select *
from t1
         join t2 on t1.c1 = t2.c1;

## cross join 即inner join
select *
from t1
         cross join t2 on t1.c1 = t2.c1;
# +----+------+----+------+
# | c1 | c2   | c1 | c2   |
# +----+------+----+------+
# |  1 |    1 |  1 |    1 |
# |  4 |    4 |  4 |    4 |
# +----+------+----+------+

## left join
select *
from t1
         left join t2 on t1.c1 = t2.c1;
# +----+------+------+------+
# | c1 | c2   | c1   | c2   |
# +----+------+------+------+
# |  1 |    1 |    1 |    1 |
# |  2 |    2 | NULL | NULL |
# |  3 |    3 | NULL | NULL |
# |  4 |    4 |    4 |    4 |
# +----+------+------+------+

## right join
select *
from t1
         right join t2 on t1.c1 = t2.c1;
# +------+------+----+------+
# | c1   | c2   | c1 | c2   |
# +------+------+----+------+
# |    1 |    1 |  1 |    1 |
# |    4 |    4 |  4 |    4 |
# | NULL | NULL |  5 |    5 |
# | NULL | NULL |  6 |    6 |
# +------+------+----+------+

## full join , 笛卡尔积 ， 4 * 4 ；
select *
from t1 full
         join t2;
# +----+------+----+------+
# | c1 | c2   | c1 | c2   |
# +----+------+----+------+
# |  1 |    1 |  1 |    1 |
# |  2 |    2 |  1 |    1 |
# |  3 |    3 |  1 |    1 |
# |  4 |    4 |  1 |    1 |
# |  1 |    1 |  4 |    4 |
# |  2 |    2 |  4 |    4 |
# |  3 |    3 |  4 |    4 |
# |  4 |    4 |  4 |    4 |
# |  1 |    1 |  5 |    5 |
# |  2 |    2 |  5 |    5 |
# |  3 |    3 |  5 |    5 |
# |  4 |    4 |  5 |    5 |
# |  1 |    1 |  6 |    6 |
# |  2 |    2 |  6 |    6 |
# |  3 |    3 |  6 |    6 |
# |  4 |    4 |  6 |    6 |
# +----+------+----+------+
