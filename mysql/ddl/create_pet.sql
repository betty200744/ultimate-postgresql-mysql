create table if not exists pet
(
    name    varchar(20),
    owner   varchar(20),
    species varchar(20),
    sex     char(1),
    birth   date,
    death   date
);
set global local_infile =1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
-- jdbc not allow
load data local infile '../data/pet.txt' into table pet;
select * from pet;
select * from pet where name = 'Bowser';

