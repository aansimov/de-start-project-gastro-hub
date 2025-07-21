WITH pizzas AS (
	SELECT r.restaurant_name,
		   (jsonb_each(r.menu -> 'Пицца')).KEY pizza_name,
	       (jsonb_each(r.menu -> 'Пицца')).value pizza_price
	  FROM cafe.restaurants r
	 WHERE r.restaurant_type = 'pizzeria'),
price_rank AS (
	SELECT p.*,
	       rank() OVER (PARTITION BY p.restaurant_name ORDER BY pizza_price DESC) rnk
	  FROM pizzas p)
SELECT restaurant_name,
       pizza_name,
       pizza_price
  FROM price_rank
 WHERE rnk = 1;