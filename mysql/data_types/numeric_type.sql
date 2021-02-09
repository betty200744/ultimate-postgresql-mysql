# numeric type
use employees;
create table numeric_type_table
(
    `id`       serial primary key,              # BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    `is_first` tinyint(1)   not null default 0, # tinyint, 2 * 8, display width 3,  for bool type, display width 1, (0 is true, nonzero is true)
    `status`   tinyint(4)   not null default 0, # tinyint, 2 * 8, display width 4, 0~255 , for enum
    `port`     smallint(5)  not null default 0, # smallint , 2 * 16, display width 5
    `room_id`  mediumint(8) not null default 0, # mediumint , 2 * 24, display width 8
    `pool_id`  mediumint(8) not null default 0, # mediumint , 2 * 24, display width 8
    `period`   int(11)      not null default 0, # int, integer , 2 * 32, display width 11
    `price`    bigint(20)   not null default 0, # bigint, 2 * 64, display width 20
    index `idx_room_id` (room_id) using btree,
    unique index `uniq_room_pool` (room_id, pool_id) using btree
) engine = InnoDB
  collate = 'utf8mb4_general_ci' comment ='numeric_type_table';
# Integer display width is deprecated and will be removed in a future release.

# c
insert into numeric_type_table(port, room_id, pool_id, period, price)
VALUES (80, 80, 80, 80, 80),
       (81, 81, 81, 81, 81),
       (82, 82, 82, 82, 82),
       (83, 83, 83, 83, 83),
       (84, 84, 84, 84, 84);
# r , read
select *
from numeric_type_table
where pool_id = 80;
# u
update numeric_type_table
set price = 88
where pool_id = 83;
# d
delete
from numeric_type_table
where pool_id = 81;


