create table if not exists projects
(
    id               uuid primary key         not null default gen_random_uuid(),
    project_name     varchar(255)             not null,
    git_url          varchar(255)             not null unique,
    languages        json,
    num_commits      integer                           default 0,
    num_contributors integer                           default 0,
    readiness        readiness                not null,
    last_sync_time   timestamp with time zone not null,
    create_time      timestamp with time zone not null default current_timestamp,
    update_time      timestamp with time zone not null default current_timestamp
);
create trigger on_update_projects
    before update
    on projects
    for each row
execute procedure trigger_set_update_time();