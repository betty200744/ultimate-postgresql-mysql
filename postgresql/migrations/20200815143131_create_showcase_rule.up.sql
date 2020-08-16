DROP TABLE IF EXISTS public.showcase_rule;
CREATE TABLE public.showcase_rule -- schema public， 权限， 命名空间
(
    id          bigserial PRIMARY KEY, -- default value bigserial , primary key constrains
    name        varchar(255),
    period      int8range                not null, -- not null constrains
    create_time timestamp with time zone not null default current_timestamp,
    update_time timestamp with time zone not null default current_timestamp
);