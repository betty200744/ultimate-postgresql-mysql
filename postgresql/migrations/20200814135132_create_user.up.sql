-- create trigger function
create or replace function trigger_set_update_time() returns trigger as
$$
begin
    NEW.update_time = now();
    RETURN NEW;
end;
$$ language plpgsql;
-- create table users
create table if not exists users
(
    id           uuid primary key                  default gen_random_uuid(),
    username     varchar(255)             not null unique,
    full_name    varchar(255),
    phone_number varchar(28),
    password     char(60),
    locations    varchar(255),
    create_time  timestamp with time zone not null default current_timestamp,
    update_time  timestamp with time zone not null default current_timestamp
);
-- create trigger
create trigger on_update_users
    before update
    on users
    for each row
execute procedure trigger_set_update_time();
