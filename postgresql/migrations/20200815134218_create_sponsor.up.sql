create table if not exists sponsor
(
    id            uuid                     not null primary key default gen_random_uuid(),
    serial_number varchar(255)             not null             default ''::varchar,
    project_id    uuid                     not null,
    fee           int8                     not null             default 0,
    sponsor_time  timestamp with time zone not null             default current_timestamp,
    create_time   timestamp with time zone not null             default current_timestamp,
    misc          jsonb                    not null             default '{}'::jsonb
);
create unique index if not exists sponsor_serial_number_index on sponsor using btree (serial_number);