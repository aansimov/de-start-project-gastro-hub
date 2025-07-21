CREATE OR REPLACE VIEW cafe.top_restaurants AS
WITH avg_check AS (
	SELECT s.restaurant_uuid,
	       ROUND(AVG(s.avg_check), 2) avg_check
	  FROM cafe.sales s
	 GROUP BY s.restaurant_uuid),
check_rank AS (
	SELECT r.restaurant_name,
	       r.restaurant_type,
           a.avg_check,
           ROW_NUMBER() OVER (PARTITION BY r.restaurant_type ORDER BY a.avg_check) check_rank
	  FROM avg_check a
	       JOIN cafe.restaurants r ON r.restaurant_uuid = a.restaurant_uuid)
SELECT r.restaurant_name,
       r.restaurant_type,
       r.avg_check
  FROM check_rank r
 WHERE r.check_rank <= 3;
