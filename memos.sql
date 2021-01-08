drop table if exists memos;
create table memos (
  id serial not null,
  title text not null,
  body text not null,
  primary key (id)
);
