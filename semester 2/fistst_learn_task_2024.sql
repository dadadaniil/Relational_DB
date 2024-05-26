1) -- In the sales_analysis database, create a table named sales_data. 
-- For the purpose of this assignment, choose the "range partitioning" approach based on the sale_date to partition the data by month.
CREATE TABLE sales_data(
    sale_id INTEGER,
    product_id INTEGER NOT NULL,
    region_id INTEGER NOT NULL,
    salesperson_id INTEGER NOT NULL,
    sale_amount NUMERIC NOT NULL,
    sale_date DATE NOT NULL ,
    PRIMARY KEY (sale_id, sale_date)
) PARTITION BY RANGE (sale_date);

2) -- Create partitions for the past 12 months. 
-- Each partition should be named in the sales_data_yyyy_mm format, where yyyy is the year and mm is the month.

CREATE TABLE sales_data_2023_01 PARTITION OF sales_data
    FOR VALUES FROM ('2023-01-01') TO ('2023-02-01');

CREATE TABLE sales_data_2023_02 PARTITION OF sales_data
    FOR VALUES FROM ('2023-02-01') TO ('2023-03-01');

CREATE TABLE sales_data_2023_03 PARTITION OF sales_data
    FOR VALUES FROM ('2023-03-01') TO ('2023-04-01');

CREATE TABLE sales_data_2023_04 PARTITION OF sales_data
    FOR VALUES FROM ('2023-04-01') TO ('2023-05-01');

CREATE TABLE sales_data_2023_05 PARTITION OF sales_data
    FOR VALUES FROM ('2023-05-01') TO ('2023-06-01');

CREATE TABLE sales_data_2023_06 PARTITION OF sales_data
    FOR VALUES FROM ('2023-06-01') TO ('2023-07-01');

CREATE TABLE sales_data_2023_07 PARTITION OF sales_data
    FOR VALUES FROM ('2023-07-01') TO ('2023-08-01');

CREATE TABLE sales_data_2023_08 PARTITION OF sales_data
    FOR VALUES FROM ('2023-08-01') TO ('2023-09-01');

CREATE TABLE sales_data_2023_09 PARTITION OF sales_data
    FOR VALUES FROM ('2023-09-01') TO ('2023-10-01');

CREATE TABLE sales_data_2023_10 PARTITION OF sales_data
    FOR VALUES FROM ('2023-10-01') TO ('2023-11-01');

CREATE TABLE sales_data_2023_11 PARTITION OF sales_data
    FOR VALUES FROM ('2023-11-01') TO ('2023-12-01');

CREATE TABLE sales_data_2023_12 PARTITION OF sales_data
    FOR VALUES FROM ('2023-12-01') TO ('2024-01-01');

3)--Write a script to generate and insert synthetic data into sales_data. 
--Ensure that the data gets correctly routed to the appropriate partitions. 
--The script should:
--Generate at least 1000 rows of synthetic data distributed across the last 12 months.
--Include a mix of product_id, region_id, and salesperson_id.

CREATE OR REPLACE FUNCTION generate_insert_data()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    sale_date DATE;
    new_sale_id INTEGER;
BEGIN
    FOR counter IN 1..1000 LOOP
    sale_date := '2023-01-01'::DATE + (FLOOR(RANDOM() * 365) * INTERVAL '1 day');
    new_sale_id := counter;

        INSERT INTO sales_data(sale_id, sale_date, salesperson_id, region_id, product_id, sale_amount)
        VALUES (
            new_sale_id,
            sale_date,
            1 + FLOOR(RANDOM() * 6), 
            1 + FLOOR(RANDOM() * 10), 
            1 + FLOOR(RANDOM() * 8),  
            40 + FLOOR(RANDOM() * 1000)  
        );
    END LOOP;
END;
$$;

SELECT generate_insert_data();

4)--Retrieve all sales in a specific month
SELECT 
TO_CHAR(sale_date, 'YYYY-MM') as  year_month,
COUNT(*) AS month_sales_count
FROM 
sales_data
GROUP BY  year_month
ORDER BY  year_month

5)-- Calculate the total sale_amount for each month
SELECT 
  TO_CHAR(sale_date, 'YYYY-MM') as  year_month, 
  SUM(sale_amount) as total_amount
FROM
sales_data
GROUP BY year_month
ORDER BY year_month

6)--Identify the top three salesperson_id values by sale_amount within a specific region across all partitions.

WITH person_sale AS (
    SELECT 
        region_id,
        salesperson_id,
        SUM(sale_amount) AS total_amount,
        RANK() OVER (PARTITION BY region_id ORDER BY SUM(sale_amount) DESC) AS person_rank
    FROM 
        sales_data
  
    GROUP BY 
        region_id, salesperson_id
)
SELECT 
    region_id,
    salesperson_id,
    total_amount
FROM 
     person_sale
WHERE 
    person_rank <= 3;
	
	
7)--Define a maintenance task to drop partitions older than 12 months and create new partitions for the next month.

CREATE OR REPLACE PROCEDURE manage_partitions()
LANGUAGE plpgsql
AS $$
DECLARE
    current_date DATE := CURRENT_DATE;
    last_year_date DATE := current_date - INTERVAL '1 year';
	partition_date_to_remove DATE;
    next_month_start DATE := DATE_TRUNC('month', current_date);
    next_month_end DATE := DATE_TRUNC('month', next_month_start) + INTERVAL '1 month';
	month_start DATE;
	month_end DATE;
	partition_date_to_add DATE;
    partition_name VARCHAR;
    next_month_name VARCHAR;
BEGIN

    FOR counter IN 0..11 LOOP
		partition_date_to_remove := last_year_date - (INTERVAL '1 month' * counter);
		partition_name := 'sales_data_' || TO_CHAR(partition_date_to_remove, 'YYYY_MM');
		IF TO_REGCLASS(partition_name) IS NOT NULL THEN
			EXECUTE FORMAT('DROP TABLE %I', partition_name);
			RAISE NOTICE 'Dropped partition: %', partition_name;
		ELSE
			RAISE NOTICE 'Partition % does not exist, skipping drop.', partition_name;
		END IF;
		
		partition_date_to_add = next_month_start - (INTERVAL '1 month' * counter);
		next_month_name := 'sales_data_' || TO_CHAR(partition_date_to_add, 'YYYY_MM');
		month_start = next_month_start - (INTERVAL '1 month' * counter);
		month_end = next_month_end - (INTERVAL '1 month' * counter);
		IF TO_REGCLASS(next_month_name) IS NULL THEN
			EXECUTE FORMAT('CREATE TABLE %I PARTITION OF sales_data FOR VALUES FROM (%L) TO (%L)', 
						   next_month_name, month_start, month_end);
			RAISE NOTICE 'Created partition: %', next_month_name;
		ELSE
			RAISE NOTICE 'Partition % already exists, skipping creation.', next_month_name;
			
			
    END IF;
	END LOOP;

END;
$$;

CALL manage_partitions();
   










	
		




	
	
	
	
	
	