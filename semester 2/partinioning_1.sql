CREATE EXTENSION postgres_fdw;

CREATE SERVER same_server_postgres
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (dbname 'db_two');

CREATE USER MAPPING FOR CURRENT_USER
    SERVER same_server_postgres
    OPTIONS (user 'postgres', password '220073dsi');
	
CREATE FOREIGN TABLE local_remote_table (
   id INTEGER,
   name VARCHAR(255),
   age INTEGER
)
SERVER same_server_postgres
OPTIONS (schema_name 'public', table_name 'remote_table');

-- Select records 
SELECT * FROM local_remote_table;

-- Insert a new record
INSERT INTO local_remote_table (id, name, age) VALUES (4, 'Yauhenia Kovalchuk', 36);

-- Update
UPDATE local_remote_table SET age = 44 WHERE name = 'Chel Chill';

-- Delete
DELETE FROM local_remote_table WHERE name = 'Joi Nakirati';

CREATE TABLE local_table (
    id serial PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO local_table (name, email) VALUES
    ('Anatoliy Chybi',  'Anatoliy.Chybi@example.com'),
    ('Joi Nakirati','Joi.Nakirati@example.com'),
    ('Chel Chill','Chel.Chill@example.com' );
	
SELECT r.*, l.email
FROM local_remote_table  r 
LEFT JOIN  local_table l ON (r.name = l.name );
	
		

