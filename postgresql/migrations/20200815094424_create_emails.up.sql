create table if not exists emails
(
    id          uuid primary key                  default gen_random_uuid(),
    user_id     uuid                              default null,
    email       varchar(255)             not null unique,
    create_time timestamp with time zone not null default current_timestamp,
    update_time timestamp with time zone not null default current_timestamp,
    foreign key (user_id) references users (id) on delete set null on update cascade
);
create trigger on_update_emails
    before update
    on emails
    for each row
execute procedure trigger_set_update_time();