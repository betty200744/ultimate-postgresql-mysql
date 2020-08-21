-- salaries
create table if not exists salaries
(
    emp_no    int  not null,
    salary    int  not null,
    from_date date not null,
    to_date   date not null,
    foreign key (emp_no) references employees (emp_no) on delete cascade,
    primary key (emp_no, from_date)
);