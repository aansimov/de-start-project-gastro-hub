INSERT INTO cafe.restaurants(restaurant_name, restaurant_type, menu)
SELECT cafe_name,
       CASE
           WHEN m.menu ? 'Пицца' THEN 'pizzeria'::cafe.restaurant_type
           WHEN m.menu ? 'Кофе' THEN 'coffee_shop'::cafe.restaurant_type
           WHEN m.menu ? 'Салат' THEN 'restaurant'::cafe.restaurant_type
           WHEN m.menu ? 'Коктейль' THEN 'bar'::cafe.restaurant_type
       END,
       m.menu
  FROM raw_data.menu m;

INSERT INTO cafe.managers(manager_name, manager_phone)
SELECT DISTINCT
       s.manager,
       s.manager_phone
  FROM raw_data.sales s;

INSERT INTO cafe.restaurant_manager_work_dates
	(restaurant_uuid,
	 manager_uuid,
	 work_start_date,
	 work_end_date)
SELECT r.restaurant_uuid,
       m.manager_uuid,
       MIN(s.report_date),
       MAX(s.report_date)
  FROM raw_data.sales s
  	   JOIN cafe.restaurants r ON r.restaurant_name = s.cafe_name
  	   JOIN cafe.managers m ON m.manager_phone = s.manager_phone
  GROUP BY r.restaurant_uuid, m.manager_uuid;

INSERT INTO cafe.sales(restaurant_uuid, date, avg_check)
SELECT r.restaurant_uuid,
       s.report_date,
       s.avg_check
  FROM raw_data.sales s
       JOIN cafe.restaurants r ON r.restaurant_name = s.cafe_name;