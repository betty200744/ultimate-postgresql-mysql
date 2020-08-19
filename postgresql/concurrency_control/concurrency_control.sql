create table if not exists accounts
(
    balance smallint,
    acctnum smallint,
    hits    smallint
);
insert into accounts
SELECT id, id, id as street
from (select generate_series(1, 1000) as id) as id;
begin;
update accounts
set balance = balance + 100
where acctnum = 1;
commit;


show default_transaction_isolation;
-- read uncommitted, 存在读取uncommitted的数据
set transaction isolation level read uncommitted;
begin;
update accounts
set balance = 202
where acctnum = 1;
select *
from accounts
where acctnum = 1;
commit;
-- read committed , 存在二次读取数据已变， 即nonrepeatable read， phantom read
set transaction isolation level read committed;
begin;
update accounts
set balance = 207
where acctnum = 1;
select *
from accounts
where acctnum = 1;
commit;


--  repeatable read, 存在phantom read，即search condition and finds 返回结果变
set transaction isolation level repeatable read;
begin;
UPDATE accounts
SET balance = balance + 100
WHERE acctnum = 1;
UPDATE accounts
SET balance = balance + 100
WHERE acctnum = 1;
select *
from accounts
where acctnum = 1;
commit;

-- serializable, 都不存在，dirty read , nonrepeatable read,phantom read, serialization
set transaction isolation level serializable;
begin;
UPDATE accounts
SET balance = balance + 100
WHERE acctnum = 1;
UPDATE accounts
SET balance = balance + 100
WHERE acctnum = 1;
select *
from accounts
where acctnum = 1;
commit;

set transaction isolation level read committed;