--  /*! STRAIGHT_JOIN */
#
explain
select *
from employees,
     departments
where employees.employees.emp_no = 10001;
-- KEY_BLOCK_SIZE
CREATE TABLE if not exists t3
(
    a INT,
    KEY (a)
);
analyze table employees;
check table employees;
optimize table employees;

explain
select *
from employees,
     departments
where employees.employees.emp_no = 10001;

show table status;

