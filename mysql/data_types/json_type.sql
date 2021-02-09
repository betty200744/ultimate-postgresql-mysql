# json_type
# javascript object type , json format strings
# json array, ["a", "b"] or ["abc", 10, null, true]
# json object,{"k1": "v1", "k2": 10}
# json set, replace, remove
# index

use employees;
drop table json_type_table;
create table json_type_table
(
    id          bigint        not null auto_increment primary key,
    price       DOUBLE(16, 2) not null default 0.00,
    product_ids json          not null default (JSON_ARRAY()),
    snapshot    json          not null default (JSON_OBJECT())

) engine = InnoDB
  default charset utf8mb4 comment 'json_type_table';

# c
insert into json_type_table(product_ids, snapshot)
VALUES ('[
  1,
  2,
  3
]', '{
  "k1": "v1",
  "k2": "v2"
}'),
       ('[
         2,
         3,
         4
       ]', '{
         "k1": "v1",
         "k2": "v2"
       }');
# u
# r
# d
# json_type(), json_array(), json_object()