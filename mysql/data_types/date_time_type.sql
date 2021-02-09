# date , time type
# type_name(fsp)  , fractional seconds part
use employees;
create table data_time_type_table
(
    `id`          bigint primary key not null auto_increment,
    `user_id`     bigint             not null default 0,
    `day`         date               not null comment '签到日期',                                                       #  3 bytes year-month-day '0000-00-00'
    `login_time`  time               not null comment '登录时间',                                                       # 3 bytes
    `trade_time`  datetime                    default current_timestamp ON UPDATE current_timestamp comment '下单时间', # 8 bytes fast then timestamp
    `create_time` timestamp          not null default current_timestamp,                                            # 4 bytes                                        # different countries
    `update_time` timestamp          not null default current_timestamp on update current_timestamp,                #  4 byte
    index idx_day (`day`) using btree
) engine = InnoDB
  collate = 'utf8mb4_general_ci' comment = 'data_time_type_table';

# c
insert into data_time_type_table(user_id, day, login_time, trade_time)
VALUES (1, '2021-02-05', '10:45:15', '2021-02-05 10:45:15'),
       (1, '2021-02-06', '10:45:15', '2021-02-06 10:45:15'),
       (1, '2021-02-07', '10:45:15', '2021-02-07 10:45:15');
# u
update data_time_type_table
set trade_time = current_timestamp
where id = 1;
# r
select *
from data_time_type_table;
# timestamp to unix
select id, unix_timestamp(create_time)
from data_time_type_table;
# do calculation datetime
select id, date_add(trade_time, interval 1 day)
from data_time_type_table;
# d
delete
from data_time_type_table
where id = 1;