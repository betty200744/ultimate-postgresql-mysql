select true and false; --logical operators
select 5 > 3; -- comparison operators
select ((2 + 3) - 3) * 2 / 2; -- match operators
select 'abc' like 'ab%'; -- pattern matching
select to_date('200001131', 'YYYYMMDD'); -- Data Type Formatting Functions

select *
from generate_series(1, 10) as id; -- Set Returning Functions
select random() < 0.01; -- Mathematical Functions and Operators
select (32 + random() * 94)::integer; -- Mathematical Functions and Operators
select to_char(current_timestamp, 'HH12:MI:SS');
create type activityStatus as enum ('Valid', 'Invalid', 'Deleted');