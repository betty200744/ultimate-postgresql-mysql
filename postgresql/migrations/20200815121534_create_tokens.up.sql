create table if not exists tokens (
  token varchar(6) primary key ,
  email varchar(255) not null ,
  expiration timestamp with time zone not null
);