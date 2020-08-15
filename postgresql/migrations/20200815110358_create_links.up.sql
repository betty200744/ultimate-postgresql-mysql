create table if not exists links
(
    id          uuid primary key                  default gen_random_uuid(),
    user_id     uuid                     not null,
    link_url    varchar(255),
    type        integer,
    create_time timestamp with time zone not null default current_timestamp,
    update_time timestamp with time zone not null default current_timestamp,
    foreign key (user_id) references users (id) on delete cascade on update cascade
);
create trigger on_update_links
    before update
    on links
    for each row
execute procedure trigger_set_update_time();
