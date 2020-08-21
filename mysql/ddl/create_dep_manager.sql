-- dep_manager
create table if not exists dep_manager
(
    emp_no    int     not null,
    dept_no   char(4) not null,
    from_date date    not null,
    to_date   date    not null,
    foreign key (emp_no) references employees (emp_no) on delete cascade,
    foreign key (dept_no) references departments (dept_no) on delete cascade,
    primary key (emp_no, dept_no)
);

-- dept_emp
create table if not exists dept_emp
(
    emp_no    int     not null,
    dept_no   char(4) not null,
    from_date date    not null,
    to_date   date    not null,
    foreign key (emp_no) references employees (emp_no) on delete cascade,
    foreign key (dept_no) references departments (dept_no) on delete cascade,
    primary key (emp_no, dept_no)
);