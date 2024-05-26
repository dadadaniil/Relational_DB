--2 SCD
ALTER TABLE DimEmployee
ADD COLUMN start_date TIMESTAMP;

ALTER TABLE DimEmployee
ADD COLUMN end_date TIMESTAMP;

ALTER TABLE DimEmployee
ADD COLUMN current_flag BOOLEAN DEFAULT TRUE;

ALTER TABLE DimEmployee
DROP constraint DimEmployee_pkey

ALTER TABLE DimEmployee
ADD COLUMN employeeHistory_ID SERIAL PRIMARY KEY  ;

UPDATE  DimEmployee
SET employeeHistory_ID = DEFAULT;


UPDATE DimEmployee
SET start_date = HireDate,
    end_date = '9999-12-31 ';
   

--create function    
CREATE OR REPLACE FUNCTION dim_employees_update_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.Title <> NEW.Title OR OLD.Address <> NEW.Address) AND OLD.current_flag AND NEW.current_flag THEN
        UPDATE DimEmployee
        SET end_date = current_timestamp,
            current_flag = FALSE,
			Title = OLD.Title,
			Address = OLD.Address
        WHERE EmployeeID = OLD.EmployeeID AND current_flag = TRUE;

      
        INSERT INTO DimEmployee (EmployeeID, LastName, FirstName, Title, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, start_date, end_date, current_flag)
        VALUES (OLD.EmployeeID, OLD.LastName, OLD.FirstName, NEW.Title, OLD.BirthDate, OLD.HireDate, NEW.Address, OLD.City, OLD.Region, OLD.PostalCode, OLD.Country, OLD.HomePhone, OLD.Extension, current_timestamp, '9999-12-31', TRUE);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


---create trigger
CREATE TRIGGER dim_employees_update
AFTER UPDATE ON DimEmployee
FOR EACH ROW
EXECUTE FUNCTION dim_employees_update_trigger();


--Checking what works
UPDATE DimEmployee
SET Address ='Brest'
WHERE FirstName = 'Don' and LastName ='Funk' AND current_flag =  True ;


UPDATE DimEmployee
SET Title ='Manager'
WHERE FirstName = 'Don' and LastName ='Funk' AND current_flag =  True ;








   