
--To install an extension
CREATE EXTENSION pg_stat_statements;

CREATE EXTENSION pgcrypto;

--Listing Installed Extensions:
SELECT * FROM pg_extension;

--Create a new table called "employees
CREATE TABLE employees (
   id serial PRIMARY KEY,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   email VARCHAR(255),
   encrypted_password TEXT
);

--Insert sample employee data into the table. 
INSERT INTO employees (first_name, last_name, email, encrypted_password) VALUES
   ('Ermolay', 'Kravchenko', 'ermolay.kravchenko@example.com', crypt('cate12367', gen_salt('bf'))),
   ('Artem', 'Rudkevich', 'artem.rudkevich@example.com', crypt('456789', gen_salt('bf'))),
   ('Robert', 'Levanowski', 'robert.Levanowskl@example.com', crypt('poland2028', gen_salt('bf')));
   
      
--Select all employees:  
SELECT * FROM employees;

--Update an employee's personal information, such as their last name
UPDATE employees SET last_name = 'Vladimirovich' WHERE email = 'artem.rudkevich@example.com';

SELECT * FROM employees;

-- Delete an employee record using the email column

DELETE FROM employees WHERE email = 'ermolay.kravchenko@example.com';

SELECT * FROM employees;

--Configure the pg_stat_statements extension
ALTER SYSTEM SET shared_preload_libraries TO 'pg_stat_statements';

ALTER SYSTEM SET pg_stat_statements.track TO 'all';

--Run the following query to gather statistics for the executed statements:
SELECT * FROM pg_stat_statements;

--- Analyze the output of the pg_stat_statements view (self-check)

--Identify the most frequently executed queries
SELECT calls, query
FROM pg_stat_statements
ORDER BY  calls  DESC



-- Determine which queries have the highest average and total runtime

SELECT calls, 
       total_exec_time, 
       rows, 
       total_exec_time / calls AS avg_time,
	   query
FROM pg_stat_statements 
ORDER BY calls DESC



















