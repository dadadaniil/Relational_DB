-- 1) Create a new user with the username "rentaluser" and the password "rentalpassword". 
     CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
--  Give the user the ability to connect to the database but no other permissions.
     GRANT CONNECT ON DATABASE dvdrental1 TO rentaluser;
-- 2) Grant "rentaluser" SELECT permission for the "customer" table.
    GRANT SELECT ON TABLE customer TO rentaluser;
--Сheck 
	SET ROLE rentaluser;
    SELECT * FROM customer;
	RESET ROLE;
--3) Create a new user group called "rental" and add "rentaluser" to the group. 
   CREATE GROUP rental;
   ALTER GROUP rental ADD USER rentaluser;
--4) Grant the "rental" group INSERT and UPDATE permissions for the "rental" table.
   GRANT INSERT,SELECT,UPDATE ON TABLE rental TO rental;
   GRANT USAGE, SELECT ON SEQUENCE rental_rental_id_seq TO rental;
--Insert a new row and update one existing row in the "rental" table under that role.
 SET ROLE rentaluser;
 SHOW ROLE ;
 INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
 VALUES (CURRENT_DATE , 123, 456, CURRENT_DATE , 5, NOW());
 UPDATE rental SET return_date = CURRENT_DATE  WHERE rental_id = 1;
 RESET ROLE;
--5) Revoke the "rental" group's INSERT permission for the "rental" table. 
  REVOKE INSERT ON TABLE rental FROM rental;
--Try to insert new rows into the "rental" table make sure this action is denied.
  SET ROLE rentaluser;
  INSERT INTO rental(rental_date,inventory_id , customer_id, return_date,staff_id ,last_update)
  VALUES(CURRENT_DATE , 234, 567, CURRENT_DATE, 890, NOW());
  RESET ROLE;
--6)Create a personalized role for any customer already existing in the dvd_rental database.
create or replace function set_new_user_role()
returns text
LANGUAGE plpgsql AS $$
DECLARE
  new_customer_id int;
  new_username text;
BEGIN
  -- Get the new role name
  SELECT c.customer_id INTO new_customer_id FROM customer c JOIN rental r ON c.customer_id = r.customer_id JOIN payment p ON c.customer_id = p.customer_id GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT r.rental_id) > 0 AND COUNT(DISTINCT p.payment_id) > 0 LIMIT 1;
  SELECT CONCAT('client_', c.first_name, '_', c.last_name) INTO new_username
  FROM customer c
  WHERE c.customer_id = new_customer_id;
  -- Convert the username to lowercase
  new_username := LOWER(new_username);
  -- Create the new role
  EXECUTE FORMAT('CREATE ROLE %I', new_username);
  EXECUTE FORMAT('GRANT CONNECT ON DATABASE dvdrental1 TO %I', new_username);
  EXECUTE FORMAT('GRANT SELECT ON TABLE rental TO %I', new_username);
  EXECUTE FORMAT('GRANT SELECT ON TABLE payment TO %I', new_username);
  ALTER TABLE rental ENABLE ROW LEVEL SECURITY;
  ALTER TABLE payment ENABLE ROW LEVEL SECURITY;
  --Create Row Security Policy for tables and new user
  EXECUTE FORMAT('CREATE POLICY new_user_policy_on_rental
  ON rental
  FOR SELECT
  TO %I
  USING (customer_id = %L)',new_username,new_customer_id);
  EXECUTE FORMAT('CREATE POLICY new_user_policy_on_payment
  ON payment
  FOR SELECT
  TO %I
  USING (customer_id = %L)',new_username,new_customer_id);
  --Set new role
  EXECUTE 'SET ROLE ' || new_username;
  RETURN new_username;
END $$;
SELECT set_new_user_role();
SELECT * FROM rental;
SELECT * FROM payment;
RESET ROLE;