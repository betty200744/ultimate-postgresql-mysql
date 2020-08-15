create table if not exists tokens
(
    token      varchar(6) primary key,
    expiration timestamp with time zone not null
);