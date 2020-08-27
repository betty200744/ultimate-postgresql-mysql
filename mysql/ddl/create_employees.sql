drop database if exists employees;
create database if not exists employees;
use employees;

drop table if exists employees;
set default_storage_engine = InnoDB;
--  employees
create table if not exists employees
(
    emp_no     int                  not null,
    birth_date date                 not null,
    first_name varchar(255)         not null,
    last_name  varchar(255)         not null,
    gender     ENUM ('M', 'F', 'U') not null default 'U',
    hire_date  date                 not null,
    primary key (emp_no)
);
drop table if exists employees;
describe employees;


# create from exits table
create table if not exists employees1 like employees;
describe employees1;

# copy data from exists table
insert into employees1
select *
from employees;
select *
from employees1;


