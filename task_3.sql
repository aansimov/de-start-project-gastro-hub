WITH manager_change AS (
	SELECT COUNT(1) changes_cnt,
	       d.restaurant_uuid
	  FROM cafe.restaurant_manager_work_dates d
	 GROUP BY d.restaurant_uuid),
change_rank AS(
	SELECT c.restaurant_uuid,
	       c.changes_cnt,
	       row_number() OVER (ORDER BY changes_cnt DESC) change_rank
	  FROM manager_change c)
SELECT r.restaurant_name,
       c.changes_cnt
  FROM change_rank c
       JOIN cafe.restaurants r USING (restaurant_uuid)
 WHERE c.change_rank <= 3;