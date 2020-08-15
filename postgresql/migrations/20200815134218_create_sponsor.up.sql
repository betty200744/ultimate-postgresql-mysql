create or replace function increment(i integer) returns integer as
$$
begin
    return i + 1; -- operators
end;
$$ language plpgsql; -- Constants Dollar-Quoted String Constants
create table if not exists sponsor
(
    id            uuid                     not null primary key default gen_random_uuid(),
    serial_number varchar(255)             not null             default ''::varchar, -- type case
    project_id    uuid                     not null,
    amount        real                     not null             default 0,           --float
    fee           int8                     not null             default 0,           --bigint
    sponsor_time  timestamp with time zone not null             default current_timestamp,
    create_time   timestamp with time zone not null             default current_timestamp,
    misc          jsonb                    not null             default '{}'::jsonb
);
create unique index if not exists sponsor_serial_number_index on sponsor using btree (serial_number);