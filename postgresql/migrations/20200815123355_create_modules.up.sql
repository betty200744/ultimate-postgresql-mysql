create table if not exists modules
(
    id          uuid primary key         not null default gen_random_uuid(),
    project_id  uuid                     not null,
    name        varchar(255)             not null,
    version     timestamp with time zone not null,
    create_time timestamp with time zone not null default current_timestamp,
    update_time timestamp with time zone not null default current_timestamp,
    foreign key (project_id) references projects (id) on delete cascade on update cascade
);
create trigger on_update_modules
    before insert
    on modules
    for each row
execute procedure trigger_set_update_time();
create index if not exists modules_version_index on modules (version);