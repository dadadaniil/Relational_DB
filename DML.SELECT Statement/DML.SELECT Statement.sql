-- 1 task
 SELECT
  s.staff_id,
   s.first_name,
   s.last_name,
   COALESCE(SUM(p.amount), 0) AS amount
 FROM staff s
 LEFT JOIN payment p ON s.staff_id = p.staff_id AND EXTRACT(YEAR FROM p.payment_date) = 2017
 GROUP BY s.staff_id, s.first_name, s.last_name
 ORDER BY amount DESC;


-- 2 task
SELECT
 film.film_id,
  COALESCE(rental_counts.film_count, 0) AS film_count,
  film.rating
 FROM film
 LEFT JOIN (
   SELECT
     i.film_id,
     COUNT(r.inventory_id) AS film_count
   FROM inventory i
   LEFT JOIN rental r ON i.inventory_id = r.inventory_id
   GROUP BY i.film_id
 ) AS rental_counts
 ON film.film_id = rental_counts.film_id
 ORDER BY film_count DESC;


-- 3 task 
SELECT
MAX(film.release_year) AS max_release_year,
film_actor.actor_id
FROM film_actor
INNER JOIN film ON film_actor.film_id = film.film_id
GROUP BY film_actor.actor_id
ORDER BY max_release_year DESC;





