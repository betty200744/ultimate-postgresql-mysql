# string type
use employees;
drop table string_type_table;
create table string_type_table
(
    id        bigint       not null auto_increment primary key,
    user_code char(4)      not null comment '用户码', # fixed length
    phone     varchar(50)  not null             default '' comment '用户手机',
    nick_name varchar(255) not null             default '' comment '用户昵称',
    gender    ENUM ('male', 'female', 'unknow') default 'unknow' comment '用户性别',
    content   text         not null comment '其他详细信息',
    index idx_phone (phone) using btree,
    unique index uniq_user_code_phone (user_code, phone) using btree
) engine InnoDb
  default charset = utf8mb4 comment 'string_type_table';

# c
insert into string_type_table(user_code, phone, nick_name, gender, content)
VALUES ('aaaa', '13476567871', 'aaaa', 'male', 'aaaa content'),
       ('bbbb', '13476567872', 'bbbb', 'male', 'bbbb content'),
       ('cccc', '13476567873', 'cccc', 'male', 'cccc content'),
       ('dddd', '13476567873', 'dddd', 'male', 'dddd content')
;
# u
update string_type_table
set phone = '13476567874'
where user_code = 'aaaa';
# r
select *
from string_type_table;
# like
select *
from string_type_table
where content like '%content%';
# regexp
select *
from string_type_table
where content REGEXP '^bbbb';
# d
delete
from string_type_table
where user_code = 'dddd';