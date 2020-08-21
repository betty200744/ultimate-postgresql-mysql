-- set type
-- enum type
-- BLOB , binary large object
-- spatial data type , geometry, point, polygon, multipoint,
-- https://stackoverflow.com/questions/29642159/how-can-i-handle-mysql-polygon-overlap-queries/29694610
create table if not exists my_data_types
(
    id                int auto_increment primary key,
    size              set ('s', 'm', 'x', 'xl', 'xxl')      not null,
    color             enum ('red', 'blue', 'white', 'gray') not null,
    comment           text,
    content           blob,
    entrance          point,
    line              linestring,
    quadrangle        polygon,
    rectangle         polygon,
    interest_position geometry,
    snapshot          json,
    tags              json,
    create_time       timestamp                             not null default current_timestamp
);

drop table my_data_types;
insert into my_data_types(size, color, comment, content, entrance, interest_position, snapshot, tags)
values ('m', 'gray', 'this is comment', 'this is content', point(2, 3),
        ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 0), '{
    "size": "s",
    "color": "red"
  }', '[
    "a",
    "b"
  ]');
insert into my_data_types(size, color, entrance)
values ('s', 'red', point(2, 3)),
       ('m,x', 'blue', point(2, 3)),
       ('m,x,xl', 'gray', point(2, 3));
insert into my_data_types(size, color, entrance, interest_position, snapshot, tags)
values ('s', 'red', point(1, 2), ST_GeomFromText('POLYGON((0 0,10 0,10 10,0 10,0 0))', 0), '{
  "size": "s",
  "color": "red"
}', '[
  "a",
  "b"
]'),
       ('m,x', 'blue', point(2, 3), ST_GeomFromText('POLYGON((10 50,50 50,50 10,10 10,10 50))', 0), '{
         "size": "m,x",
         "color": "blue"
       }', '[
         "a",
         "b"
       ]'),
       ('m,x,xl', 'gray', point(2, 3), ST_GeomFromText('POLYGON((1 15,5 15,5 11,1 11,1 15))', 0), '{}', '[
         "a",
         "b"
       ]');

select *
from my_data_types;
select *
from my_data_types
where size = 's';
select *
from my_data_types
where color = 'red';
