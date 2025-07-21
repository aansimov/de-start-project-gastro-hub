BEGIN; --Уровень READ COMMITTED нам подойдет
	
	SELECT *
	  FROM cafe.restaurants r
	 WHERE r.restaurant_type = 'coffee_shop'
	   AND r.menu -> 'Кофе' ? 'Капучино'
	   FOR NO KEY UPDATE; --Будем обновлять меню, а это не ключевое поле
	
	WITH capuccino_price AS (
		SELECT r.restaurant_uuid,
		       round(((r.menu #>> '{Кофе, Капучино}')::NUMERIC) * 1.2) new_price
		  FROM cafe.restaurants r
		 WHERE r.restaurant_type = 'coffee_shop'
	   	   AND r.menu -> 'Кофе' ? 'Капучино')
	UPDATE cafe.restaurants r
	   SET menu = jsonb_set(r.menu, '{Кофе, Капучино}', to_jsonb(p.new_price))
	  FROM capuccino_price p
	 WHERE p.restaurant_uuid = r.restaurant_uuid;

COMMIT;
