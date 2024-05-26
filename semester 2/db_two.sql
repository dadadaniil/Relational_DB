-- Create a sample table
CREATE TABLE remote_table (
    id serial PRIMARY KEY,
    name VARCHAR(255),
    age INTEGER
);

-- Insert sample data into the table
INSERT INTO remote_table (name, age) VALUES
    ('Ermolya Krravchenko', 21),
    ('Ksenya Veka', 34),
    ('Yan Marchan', 29);


