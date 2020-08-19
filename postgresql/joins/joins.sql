create table if not exists t1
(
    num  int,
    name varchar(16)
);
create table if not exists t2
(
    num  int,
    name varchar(16)
);
insert into t1
values (1, 'a'),
       (2, 'b'),
       (3, 'c');
insert into t2
values (1, 'xxx'),
       (3, 'yyy'),
       (5, 'zzz');

-- cross join, 笛卡尔积 ,没有on
select *
from t1
         cross join t2;

-- inner join, 有on
select *
from t1
         inner join t2 on t1.num = t2.num;
select *
from t1
         inner join t2 using (num);

-- left join, 保留left, 置null
select *
from t1
         left join t2 on t1.num = t2.num;

-- right join, 保留right, 置null
select * from t1 right join t2 on t1.num = t2.num;

-- full join, 两边都保留， 置null
select *  from t1 full join t2  on t1.num = t2.num;