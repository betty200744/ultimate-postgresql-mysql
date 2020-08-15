create table if not exists team
(
    id               uuid                     not null default gen_random_uuid(),
    name             varchar(2555)            not null,
    manager_user_id  uuid,
    num_partner_text varchar,
    domains_str      varchar,
    create_time      timestamp with time zone not null default current_timestamp,
    update_time      timestamp with time zone not null default current_timestamp,
    primary key (id)
);
create trigger on_update_team
    before update
    on team
    for each row
execute procedure trigger_set_update_time();