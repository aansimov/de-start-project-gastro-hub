WITH pizzas AS (
	SELECT r.restaurant_name,
		   (jsonb_each(r.menu -> 'Пицца')).key,
	       (jsonb_each(r.menu -> 'Пицца')).value
	  FROM cafe.restaurants r
	 WHERE r.restaurant_type = 'pizzeria'),
pizza_cnt AS (
	SELECT p.restaurant_name,
	       COUNT(1) pizza_cnt
	  FROM pizzas p
	 GROUP BY p.restaurant_name),
cnt_rank AS (
	SELECT p.*,
	       rank() OVER (ORDER BY p.pizza_cnt DESC) rnk
	  FROM pizza_cnt p)
SELECT restaurant_name,
       pizza_cnt
  FROM cnt_rank
 WHERE rnk = 1;
 