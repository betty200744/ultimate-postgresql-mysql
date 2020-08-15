create table if not exists donation
(
    id              uuid                     not null primary key default gen_random_uuid(),
    serial_number   varchar(255)             not null             default ''::varchar,
    project_id      uuid                     not null,
    amount          int8                     not null             default 0,
    fee             int8                     not null             default 0,
    balance_detail  jsonb                    not null             default '{}'::jsonb,
    donation_status int4                     not null             default 0,
    donation_time   timestamp with time zone not null             default current_timestamp,
    create_time     timestamp with time zone not null             default current_timestamp,
    misc            jsonb                    not null             default '{}'::jsonb
);
create unique index donation_serial_number_index on donation using btree (serial_number);