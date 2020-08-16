insert into user_log (logdate)
values ('2020-08-01');
insert into user_log (logdate)
values ('2020-08-01');
insert into user_log (logdate)
values ('2020-08-01');
insert into user_log (logdate)
values ('2020-09-02');
insert into user_log (logdate)
values ('2020-09-03');
set enable_partition_pruning = on;
explain analyse select * from user_log;
explain analyse select count(*) from user_log where logdate > date '2020-08-01' ;
