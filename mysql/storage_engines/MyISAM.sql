#
create table t_myisam
(
    emp_no    int     not null,
    dept_no   char(4) not null,
    from_date date    not null,
    to_date   date    not null,
    foreign key (emp_no) references employees (emp_no) on delete cascade,
    foreign key (dept_no) references departments (dept_no) on delete cascade,
    primary key (emp_no, dept_no)
) ENGINE = MYISAM;

show create table t_myisam;
start transaction;
insert into t_myisam(emp_no, dept_no, from_date, to_date)
values (3, 3, current_date, current_date);
insert into t_myisam(emp_no, dept_no, from_date, to_date)
values (4, 4, current_date, current_date);
commit;
select *
from t_myisam;