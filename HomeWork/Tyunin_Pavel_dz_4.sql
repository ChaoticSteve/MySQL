drop database if exists vk;
create database vk;
use vk;

drop table if exists users;
create table users (
	id serial,
	firstname varchar(50),
	lastname varchar(50),
	email varchar(120),
	phone bigint unsigned unique,
	passwarod_hash varchar(100),
	
	PRIMARY KEY (id),
	index users_firstname_lastname_idx(firstname, lastname)
	
);

drop table if exists profiles;
create table profiles (
	user_id bigint unsigned not null unique,
	gender char(1),
	birthday date,
	photo_id bigint unsigned not null,
	created_at datetime default now(),
	hometown varchar(100),
	
	foreign key (photo_id) references media(id)
);

alter table `profiles` add constaint fk_user_id
	foreign key (user_id) references user(id)
	on update cascade
	on delete restrict;

drop table if exists messages;
create table messages (
	id serial,
	from_user_id bigint unsigned not null,
	to_user_id bigint unsigned not null,
	body text,
	created_at datetime default now(),
	
	foreign key (from_user_id) references users(id),
	foreign key (to_user_id) references users(id)
);

drop table if exists freind_requsts;
create table friend_requsts (
	initiator_user_id bigint unsigned not null,
	target_user_id bigint unsigned not null,
	`status` enum('requested', 'approved', 'declined', 'unfriended'),
	requested_at datetime default now(),
	updated_at datetime on update current_timestamp,
	
	primary key (initiator_user_id, target_user_id),
	foreign key (initiator_user_id) references users(id),
	foreign key (target_user_id) references users(id)
);

alter table friend_requsts
add check(initiator_user_id <> target_user_id);

drop table if exists communities;
create table communities (
	id serial,
	name varchar(150),
	admin_user_id bigint unsigned not null,
	
	index communities_name_idx(name),
	foreign key(admin_user_id) references users(id)
);

drop table if exists users_communities;
create table users_communities (
	user_id bigint unsigned not null,
	community_id bigint unsigned not null,
	
	primary key (user_id, community_id),
	foreign key (user_id) references user(id),
	foreign key (community_id) references communities(id)
);

drop table if exists media_types;
create table media_types (
	id serial,
	name varchar(255),
	created_at datetime deafult now(),
	updated_at datetime on update current_timestamp
);

drop table if exists media;
create table media (
	id serial,
	media_type_id bigint unsigned not null,
	user_id bigint unsigned not null,
	body text,
	filename varchar(150),
	`size` int,
	metadata json,
	created_at datetime default now(),
	updated_at datetime on update current_timestamp,
	
	foreign key (user_id) REFERENCES users(id), -- внезапно DBeaver начал самостоятельно на большие буквы исправлять
	FOREIGN KEY (media_type_id) REFERENCES media_types(is)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id serial,
	user_id bigint unsigned not NULL,
	media_id bigint unsigned NOT NULL,
	created_at datetime DEFAULT now(),
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS photo_albums,
CREATE TABLE photo_albums (
	id serial,
	name varchar(255),
	user_id bigint unsigned NOT NULL,
	
	FOREIGN KEY (user_id) REFERENCES users(id),
	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS photos,
CREATE TABLE photos (
	id serial,
	album_id bigint unsigned NOT NULL,
	media_id bigint unsigned NOT NULL,
	
	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS documet_types;
CREATE TABLE document_types (
	id serial,
	name varchar(255),
	created_at datetime DEFAULT now(),
	updated_at datetime ON UPDATE current_timestamp
);

DROP TABLE IF EXISTS documents;
CREATE TABLE documents (
	id serial,
	document_type_id bigint unsigned NOT NULL,
	user_id bigint unsigned NOT NULL,
	filename varchar(255),
	`size` int,
	created_at datetime DEFAULT now(),
	updated_at datetime ON UPDATE current_timestamp,
	
	FOREIGN KEY (document_type_id) REFERENCES document_types(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF exists games;
CREATE TABLE games (
	id serial,
	name varchar(150),
	genre varchar(150),
	
	INDEX games_name_idx(name),
);

DROP TABLE IF EXISTS users_games;
CREATE TABLE users_games (
	user_id bigint unsigned NOT NULL,
	game_id bigint unsigned NOT NULL,
	
	PRIMARY KEY (user_id, game_id),
	FOREIGN KEY (user_id) references users(id),
	FOREIGN KEY (game_id) REFERENCES games(is)
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);