--  departments
create table if not exists departments
(
    dept_no   char(4)     not null,
    dept_name varchar(40) not null,
    primary key (dept_no),
    unique key (dept_name)
);
describe departments;

