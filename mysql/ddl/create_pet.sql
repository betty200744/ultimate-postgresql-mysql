create table if not exists pet
(
    id      int auto_increment primary key,
    name    varchar(20),
    owner   varchar(20),
    species varchar(20),
    sex     char(1),
    birth   date,
    death   date
#     primary key (id)
#     constraint primary key (id)
#     index name_index using btree (name desc)

);
describe pet;
drop table pet;
set global local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
-- jdbc not allow
load data local infile '../data/pet.txt' into table pet;
select *
from pet;
select *
from pet
where name = 'Bowser';

