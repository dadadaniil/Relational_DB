

--1 Choose one of your favorite films and add it to the "film" table. Fill in rental rates with 4.99 and rental durations with 2 weeks.
INSERT INTO film (title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, last_update, special_features, fulltext	)
VALUES ('Metropolis', 'A look of people from the past on our modernity ', 1927, 1, null, 14, 4.99, 180, 19.99, 'R', CURRENT_TIMESTAMP, '{"Special Features Here"}', 'Full Text Here');	


--2 Add the actors who play leading roles in your favorite film to the "actor" (three or more actors in total).
INSERT INTO actor (first_name, last_name, last_update)
VALUES
    ('Alfred','Abel', CURRENT_TIMESTAMP),
    ('Gustav ', 'Fröhlich', CURRENT_TIMESTAMP);
    ('Rudolf', 'Klein-Rogge', CURRENT_TIMESTAMP),
	
INSERT INTO film_actor (actor_id, film_id, last_update)
VALUES
    ((SELECT actor_id FROM actor WHERE first_name = 'Alfred' ), (SELECT film_id FROM film WHERE title = 'Metropolis'), CURRENT_TIMESTAMP),
    ((SELECT actor_id FROM actor WHERE first_name = 'Rudolf' ), (SELECT film_id FROM film WHERE title = 'Metropolis'), CURRENT_TIMESTAMP),
    ((SELECT actor_id FROM actor WHERE first_name = ' Gustav ' ), (SELECT film_id FROM film WHERE title = 'Metropolis'), CURRENT_TIMESTAMP);
	
--3 Add your favorite movies to any store's inventory.


INSERT INTO film (title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, last_update, special_features, fulltext)
VALUES
    ('A Forbidden Orange', 'Antiutopie about clash of subsessive Spain regime and censors', 2021, 1, NULL, 14, 4.99, 117, 19.99, 'R', CURRENT_TIMESTAMP, '{"Special Features Here"}', 'Full Text Here'),
    ('The Grapes of Wrath ', 'About a poor family of tenant farmers driven from their Oklahoma home by drought, economic hardship', 1940, 2, NULL, 7, 3.99, 129, 14.99, 'R', CURRENT_TIMESTAMP, '{"Special Features Here"}', 'Full Text Here'),
    ('The Third Man', 'About mystery', 1949, 1, NULL, 10, 2.99, 104, 24.99, 'R', CURRENT_TIMESTAMP, '{"Special Features Here"}', 'Full Text Here');



INSERT INTO inventory (film_id, store_id , last_update)
VALUES
     ((SELECT film_id FROM film WHERE title = 'Metropolis' LIMIT 1 ),  (SELECT store_id FROM store WHERE store_id IN (1, 2) LIMIT 1 ), CURRENT_TIMESTAMP),
     ((SELECT film_id FROM film WHERE title = 'A Forbidden Orange' LIMIT 1 ),  (SELECT store_id FROM store WHERE store_id IN (1, 2) LIMIT 1 ), CURRENT_TIMESTAMP),
	 ((SELECT film_id FROM film WHERE title = 'The Grapes of Wrath ' LIMIT 1 ),   (SELECT store_id FROM store WHERE store_id IN (1, 2) LIMIT 1), CURRENT_TIMESTAMP),
	 ((SELECT film_id FROM film WHERE title = 'The Third Man' LIMIT 1),   (SELECT store_id FROM store WHERE store_id IN (1, 2) LIMIT 1), CURRENT_TIMESTAMP);








