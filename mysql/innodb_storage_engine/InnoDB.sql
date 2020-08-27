show engines ;
select * from information_schema.ENGINES;

# show table properties

# DDL
create table t_innodb
(
    emp_no    int     not null,
    dept_no   char(4) not null,
    from_date date    not null,
    to_date   date    not null,
    foreign key (emp_no) references employees (emp_no) on delete cascade,
    foreign key (dept_no) references departments (dept_no) on delete cascade,
    primary key (emp_no, dept_no)
) engine INNODB;

describe t_innodb;
show create table t_innodb;

# DML

start transaction;
insert into t_innodb(emp_no, dept_no, from_date, to_date)
values (1, 1, current_date, current_date); -- error
insert into t_innodb(emp_no, dept_no, from_date, to_date)
values (2, 2, current_date, current_date); -- error
commit;
select *
from t_innodb;

# default primary key
create table t_innodb_1(a int primary key , b char(20)) engine=innodb;
drop table t_innodb_1;
describe t_innodb_1;
insert into t_innodb_1(a, b) values (1, '1'), (2, '2'), (3, '3');
explain analyze select * from t_innodb_1 where a < 4;

# default row format
create table if not exists t_innodb_2(a int primary key , b char(20)) row_format=dynamic;
describe t_innodb_2;