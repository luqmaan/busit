CREATE TABLE stops (
  stop_id integer PRIMARY KEY NOT NULL,
  stop_code integer(128) NOT NULL,
  stop_name varchar(128) NOT NULL,
  stop_lat double(128) NOT NULL,
  stop_lon double(128) NOT NULL
);
CREATE TABLE stop_times (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  trip_id integer NOT NULL,
  arrival_time varchar(128) NOT NULL,
  departure_time varchar(128) NOT NULL,
  stop_id integer NOT NULL,
  stop_sequence integer NOT NULL,
  pickup_type integer NOT NULL,
  drop_off_type integer NOT NULL
);
CREATE TABLE trips (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  route_id integer NOT NULL,
  service_id varchar(3) NOT NULL,
  trip_id integer NOT NULL,
  trip_headsign varchar(128) NOT NULL,
  block_id integer NOT NULL,
  shape_id integer NOT NULL,
  direction_id integer NOT NULL,
  direction varchar(128) NOT NULL
);
CREATE TABLE calendar (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,                       
  service_id varchar(3) NOT NULL,
  monday integer NOT NULL,
  tuesday integer NOT NULL,
  wednesday integer NOT NULL,
  thursday integer NOT NULL,
  friday integer NOT NULL,
  saturday integer NOT NULL,
  sunday integer NOT NULL,
  start_date integer NOT NULL,
  end_date integer NOT NULL
);
CREATE TABLE routes (
  route_id integer PRIMARY KEY NOT NULL,
  route_short_name varchar(128) NOT NULL,
  route_long_name varchar(128) NOT NULL,
  route_type integer NOT NULL,
  route_url varchar(256) NOT NULL,
  route_color char(6) NOT NULL,
  route_text_color char(6) NOT NULL
);
CREATE TABLE shapes (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  shape_id integer NOT NULL,
  shape_pt_lat double(128) NOT NULL,
  shape_pt_lon double(128) NOT NULL,
  shape_pt_sequence integer NOT NULL
);
CREATE TABLE calendar_dates (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,                             
  service_id char(3) NOT NULL,
  date integer NOT NULL,
  exception_type integer NOT NULL
);
CREATE TABLE fare_attributes (
  id integer PRIMARY KEY NOT NULL,
  fare_id integer NOT NULL,
  price double(8) NOT NULL,
  currency_type double(8) NOT NULL,
  payment_method char(8) NOT NULL,
  transfers double(8) NOT NULL
);
CREATE TABLE fare_rules (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  fare_id integer NOT NULL,
  route_id integer NOT NULL
);
