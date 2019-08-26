CREATE TABLE t_spire (
  guid varchar(100) not null primary key,
  persona varchar(60) not null,
  img_file_lg varchar(150) null,
  img_file_sm varchar(150) null,
  title varchar(1000) null,
  text varchar(700) null,
  created_at timestamp not null
);




