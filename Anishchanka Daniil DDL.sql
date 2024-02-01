-- 1)Create a view called "sales_revenue_by_category_qtr" that shows the film category and total sales revenue for the current quarter. 
--The view should only display categories with at least one sale in the current quarter. The current quarter should be determined dynamically.

CREATE OR REPLACE VIEW sales_revenue_by_category_qtr AS
SELECT c.name AS category,
    COALESCE(sum(p.amount), 0::numeric) AS total_sales_revenue
   FROM category c
     JOIN film_category fc ON c.category_id = fc.category_id
     JOIN film f ON fc.film_id = f.film_id
     LEFT JOIN inventory i ON f.film_id = i.film_id
     LEFT JOIN rental r ON i.inventory_id = r.inventory_id
     LEFT JOIN payment p ON r.rental_id = p.rental_id
  WHERE EXTRACT(year FROM CURRENT_DATE) = EXTRACT(year FROM p.payment_date) AND EXTRACT(quarter FROM CURRENT_DATE) = EXTRACT(quarter FROM p.payment_date)
  GROUP BY c.name
  ORDER BY (sum(p.amount)) ASC;

-- 2) Create a query language function called "get_sales_revenue_by_category_qtr" that accepts one parameter representing the current quarter and returns the same result 
--as the "sales_revenue_by_category_qtr" view.
CREATE FUNCTION get_sales_revenue_by_category_qtr(current_quarter DATE)
RETURNS TABLE (category TEXT, total_sales_revenue NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	
    SELECT c.name AS category,
    COALESCE(sum(p.amount), 0::numeric) AS total_sales_revenue
   FROM category c
     JOIN film_category fc ON c.category_id = fc.category_id
     JOIN film f ON fc.film_id = f.film_id
     LEFT JOIN inventory i ON f.film_id = i.film_id
     LEFT JOIN rental r ON i.inventory_id = r.inventory_id
     LEFT JOIN payment p ON r.rental_id = p.rental_id
  WHERE EXTRACT(year FROM current_quarter) = EXTRACT(year FROM p.payment_date) AND EXTRACT(quarter FROM current_quarter) = EXTRACT(quarter FROM p.payment_date)
  GROUP BY c.name
  ORDER BY (sum(p.amount)) ASC;

END;
$$

--3)Create a procedure language function called "new_movie" that takes a movie title as a parameter and inserts a new movie with the given title in the film table. 
--The function should generate a new unique film ID, set the rental rate to 4.99, the rental duration to three days, the replacement cost to 19.99, the release year to the current year, and "language" as Klingon. 
--The function should also verify that the language exists in the "language" table. Then, ensure that no such function has been created before; if so, replace it.
CREATE OR REPLACE PROCEDURE new_movie(movie_title VARCHAR DEFAULT 'Rambo')
LANGUAGE plpgsql
AS $$
DECLARE
    s_language_id INT;
    new_film_id INT;
BEGIN
    
    SELECT language_id INTO s_language_id
    FROM language
    WHERE name = 'Klingon';

    IF s_language_id IS NULL THEN
        RAISE EXCEPTION 'Language "Klingon" does not exist.';
    END IF;

  
    SELECT COALESCE(MAX(film_id), 0) + 1 INTO new_film_id
    FROM film;

  
    INSERT INTO film (film_id, title, rental_rate, rental_duration, replacement_cost, release_year, language_id)
    VALUES (new_film_id, movie_title, 4.99, 3, 19.99, EXTRACT(YEAR FROM CURRENT_DATE), s_language_id);
END;
$$
