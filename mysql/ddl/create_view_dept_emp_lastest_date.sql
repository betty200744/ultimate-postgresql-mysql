-- create view
create or replace view dept_emp_latest_date as
select emp_no, max(from_date) as from_date, max(to_date) as to_date
from dept_emp
group by emp_no;


create or replace view current_dept_emp as
select deld.emp_no, dept_no, deld.from_date, deld.to_date
from dept_emp as d
         inner join dept_emp_latest_date deld
                    on d.emp_no = deld.emp_no and d.from_date = deld.from_date and d.to_date = deld.to_date;