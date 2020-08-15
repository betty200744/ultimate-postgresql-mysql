DROP TABLE IF EXISTS showcase_rule;
CREATE TABLE showcase_rule
(
    id          bigserial PRIMARY KEY,
    name        varchar(255),
    period      int8range                not null,
    create_time timestamp with time zone not null default current_timestamp,
    update_time timestamp with time zone not null default current_timestamp
);