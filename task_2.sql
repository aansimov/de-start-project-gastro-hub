CREATE MATERIALIZED VIEW cafe.restaurant_avg_check_change AS
WITH avg_check AS (
	SELECT s.restaurant_uuid,
	       EXTRACT(YEAR FROM s.date) yr,
	       round(avg(s.avg_check), 2) avg_check
	  FROM cafe.sales s
	 WHERE EXTRACT(YEAR FROM s.date) != 2023
	 GROUP BY s.restaurant_uuid,
	          EXTRACT(YEAR FROM s.date)),
prev_avg_check AS (
	SELECT a.*,
	       lag(a.avg_check) OVER (PARTITION BY a.restaurant_uuid ORDER BY yr) prev_avg_check
	  FROM avg_check a)
SELECT p.yr "year",
       r.restaurant_name,
       r.restaurant_type,
       p.avg_check,
       p.prev_avg_check,
       round(((p.avg_check - p.prev_avg_check) / p.avg_check) * 100, 2) avg_check_change
  FROM prev_avg_check p
       JOIN cafe.restaurants r USING (restaurant_uuid);