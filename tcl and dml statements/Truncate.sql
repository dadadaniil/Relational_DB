--1   Remove a previously inserted film from the inventory and all corresponding rental records
-- Delete from rental table
DELETE FROM rental
WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = 'Metropolis' LIMIT 1));

-- Delete from inventory table
DELETE FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Metropolis' LIMIT 1);




--2 Remove any records related to you (as a customer) from all tables except "Customer" and "Inventory"

DELETE FROM payment
WHERE customer_id = (SELECT customer_id
    FROM customer
    WHERE first_name = 'Daniil'  AND last_name = 'Anishchanka'
    );
	
DELETE FROM rental
WHERE customer_id = (SELECT customer_id
    FROM customer	
    WHERE first_name = 'Daniil'  AND  last_name = 'Anishchanka'
    );

