create role chirpstack_ns with login password 'chirpstack_ns';
create database chirpstack_ns with owner chirpstack_ns;

create role chirpstack_as with login password 'chirpstack_as';
create database chirpstack_as with owner chirpstack_as;

create extension pg_trgm;
create extension hstore;