CREATE SCHEMA cafe;

CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

CREATE TABLE cafe.restaurants (
	restaurant_uuid uuid NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	restaurant_name text NOT NULL UNIQUE,
	restaurant_type cafe.restaurant_type NOT NULL,
	menu jsonb NOT NULL
);

CREATE TABLE cafe.managers (
	manager_uuid uuid NOT NULL PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	manager_name text NOT NULL,
	manager_phone text NOT NULL
);

CREATE TABLE cafe.restaurant_manager_work_dates(
	restaurant_uuid uuid NOT NULL REFERENCES cafe.restaurants(restaurant_uuid),
	manager_uuid uuid NOT NULL REFERENCES cafe.managers(manager_uuid),
	work_start_date DATE NOT NULL,
	work_end_date DATE NOT NULL,
	PRIMARY KEY (restaurant_uuid, manager_uuid)
);

CREATE TABLE cafe.sales(
	restaurant_uuid uuid NOT NULL REFERENCES cafe.restaurants(restaurant_uuid),
	date DATE NOT NULL,
	avg_check numeric(6, 2) NOT NULL,
	PRIMARY KEY (restaurant_uuid, date)
);
