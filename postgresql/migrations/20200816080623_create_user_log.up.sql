create table if not exists user_log
(
    id      bigserial,
    user_id uuid not null default gen_random_uuid(),
    logdate date not null default current_timestamp
) partition by range (logdate);
create table user_log_202008 partition of user_log for values from ('2020-08-01') to ('2020-09-01');
create table user_log_202009 partition of user_log for values from ('2020-09-01') to ('2020-10-01');