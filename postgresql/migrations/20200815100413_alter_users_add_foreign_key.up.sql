alter table users
    add column primary_email_id UUID UNIQUE;
alter table users
    add foreign key (primary_email_id) references emails (id) on delete restrict on update cascade;
