-- titles
create table if not exists titles
(
    emp_no    int  not null,
    title     varchar(50),
    from_date date not null,
    to_date   date not null,
    foreign key (emp_no) references employees (emp_no) on delete cascade,
    primary key (emp_no, title, from_date)
);