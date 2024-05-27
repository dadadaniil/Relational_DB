CREATE EXTENSION pg_stat_statements;

CREATE EXTENSION pgcrypto;

SELECT * FROM pg_extension;

CREATE TABLE employees (
   id serial PRIMARY KEY,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   email VARCHAR(255),
   encrypted_password TEXT
);

INSERT INTO employees (first_name, last_name, email, encrypted_password) VALUES
   ('mia', 'kurasava', 'mia.kurasava@tiani.hao', crypt('39848', gen_salt('bf'))),
   ('Daniil', 'Anishchanka', 'anishchanka.daniil@student.ehu.lt', crypt('encryptedaniil', gen_salt('bf'))),
   ('yahor', 'sake', 'yahor.Levanowskl@example.com', crypt('ANT4TE', gen_salt('bf')));
   
      
SELECT * FROM employees;

UPDATE employees SET last_name = 'Vladimirovich' WHERE email = 'sake.Kurasava@example.com';

SELECT * FROM employees;

ALTER SYSTEM SET shared_preload_libraries TO 'pg_stat_statements';

ALTER SYSTEM SET pg_stat_statements.track TO 'all';

SELECT * FROM pg_stat_statements;

SELECT calls, query
FROM pg_stat_statements
ORDER BY  calls  DESC

SELECT calls, 
       total_exec_time, 
       rows, 
       total_exec_time / calls AS avg_time,
	   query
FROM pg_stat_statements 
ORDER BY calls DESC
