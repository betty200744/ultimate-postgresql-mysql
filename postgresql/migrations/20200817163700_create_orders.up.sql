CREATE EXTENSION if not exists hstore;

create table if not exists orders
(
    id         uuid primary key not null default gen_random_uuid(),
    products    uuid[],                                       -- array
    info       jsonb,                                        -- jsonb
    meta       json                      default '{}'::json, -- json
    screenshot hstore                                        -- hstore
);