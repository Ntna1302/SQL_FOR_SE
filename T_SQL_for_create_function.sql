

-- GET TYPENAME FROM PID
SELECT DISTINCT TName FROM Type t INNER JOIN Product_Category pc ON t.TID = pc.TID JOIN Product p ON pc.PID = <<REFERENCE_SKU>>;

-----------------QUERY TO EDIT THE PRODUCT
UPDATE Product
SET
    Pname = COALESCE('Product_6_1', 'Product6'),
    SupplierName = COALESCE('Supplier2', 'Supplier1'),
    SID= COALESCE((SELECT SID FROM Supplier WHERE SupplierName = 'Supplier2'),(SELECT SID FROM Supplier WHERE SupplierName = 'Supplier1') ),
    CostPrice = COALESCE(NULL, CostPrice),
    UnitPrice = COALESCE(NULL, UnitPrice)
WHERE PID = 'P006' ;




---------------------------------------------------------------


UPDATE Product_Category
SET
    TID = COALESCE((SELECT TID FROM Type WHERE TName  = <<INPUT_CATEGORY>>), (SELECT TID FROM Type WHERE TName = <<REFERENCE_CATEGORY>>))
WHERE
    PID = <<REFERENCE_PID>>;
--------- AUTO INSERT TO EXPORT HISTORY
CREATE OR REPLACE FUNCTION insert_export_history()
    RETURNS TRIGGER AS $$
DECLARE
    new_pid varchar(100);
BEGIN
    SELECT p.PID INTO new_pid
    FROM Product p
    WHERE p.PName = NEW.ProductName AND p.SupplierName = NEW.SupplierName;


    INSERT INTO Export_History (PID, WName, ProductName, SupplierName, EID, ExportQuantity, ExportDate , EmployeeName )
    VALUES (new_pid, NEW.WName, NEW.ProductName, NEW.SupplierName, NEW.EID, NEW.ExportQuantity, NEW.ExportDate , NEW.EmployeeName  );

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER export_insert_trigger
    AFTER INSERT ON Export
    FOR EACH ROW
EXECUTE FUNCTION insert_export_history();

drop trigger export_insert_trigger on Export;
--------------------------------------





DO $$
    DECLARE
        v_max_capacity INTEGER;
        v_current_quantity INTEGER;
        v_new_quantity INTEGER;
        v_product_id varchar(100);
    BEGIN
        -- Get the max capacity of the warehouse
        SELECT wcapacity INTO v_max_capacity
        FROM Warehouse_Capacity
        WHERE WName = 'Warehouse1';

        -- Get the product ID for 'Product9' from 'Supplier1'
        SELECT PID INTO v_product_id
        FROM Product
        WHERE Pname = 'Product1' AND SupplierName = 'Supplier1';

        -- Calculate the current quantity of all products in the warehouse
        SELECT COALESCE(SUM(Quantity), 0) INTO v_current_quantity
        FROM Product_Warehouse
        WHERE WName = 'Warehouse1';

        -- Calculate the new quantity that would be in the warehouse after adding the new quantity
        v_new_quantity := v_current_quantity + 5;

        -- Check if the new quantity exceeds the max capacity
        IF v_new_quantity > v_max_capacity THEN
            RAISE EXCEPTION 'Total quantity % exceeds max capacity % in %', v_new_quantity, v_max_capacity, 'Warehouse2';
        ELSE
            -- Perform the insert or update
            INSERT INTO Product_Warehouse (WName, PID, Quantity, LastUpdatedDate, LastUpdatedTime, Status)
            VALUES (
                       'Warehouse1',
                       v_product_id,
                       5,
                       TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'DD/MM/YYYY'),
                       TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'HH24:MI:SS'),
                       CASE
                           WHEN v_new_quantity  <= 0 THEN 'Out of Stock'
                           WHEN v_new_quantity < 10 THEN 'Low Stock'
                           ELSE 'In Stock'
                           END
                   )
            ON CONFLICT (PID, WName) DO UPDATE SET
                                                   Quantity = Product_Warehouse.Quantity + EXCLUDED.Quantity,
                                                   LastUpdatedDate = TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'DD/MM/YYYY'),
                                                   LastUpdatedTime = TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'HH24:MI:SS'),
                                                   Status = CASE
                                                                WHEN (Product_Warehouse.Quantity + EXCLUDED.Quantity) <= 0 THEN 'Out of Stock'
                                                                WHEN (Product_Warehouse.Quantity + EXCLUDED.Quantity) < 10 THEN 'Low Stock'
                                                                ELSE 'In Stock'
                                                       END;
        END IF;
    END $$;

DO $$
    DECLARE
        v_max_capacity INTEGER;
        v_current_quantity INTEGER;
        v_new_quantity INTEGER;
        v_product_id varchar(100);
        v_order_row record;
    BEGIN
        -- Loop through each row in Product_Order table
        FOR v_order_row IN
            SELECT * FROM Product_Order
            LOOP
                -- Get the max capacity of the warehouse
                SELECT wcapacity INTO v_max_capacity
                FROM Warehouse_Capacity
                WHERE WName = v_order_row.WarehouseName;

                -- Get the product ID for the current row
                SELECT PID INTO v_product_id
                FROM Product
                WHERE Pname = v_order_row.ProductName AND SupplierName = v_order_row.SupplierName;

                -- Calculate the current quantity of all products in the warehouse
                SELECT COALESCE(SUM(Quantity), 0) INTO v_current_quantity
                FROM Product_Warehouse
                WHERE WName = v_order_row.WarehouseName;

                -- Calculate the new quantity that would be in the warehouse after adding the new quantity
                v_new_quantity := v_current_quantity + v_order_row.OrderQuantity;

                -- Check if the new quantity exceeds the max capacity
                IF v_new_quantity > v_max_capacity THEN
                    RAISE EXCEPTION 'Total quantity % exceeds max capacity % in %', v_new_quantity, v_max_capacity, v_order_row.WarehouseName;
                ELSE
                    -- Perform the insert or update
                    INSERT INTO Product_Warehouse (WName, PID, Quantity, LastUpdatedDate, LastUpdatedTime, Status)
                    VALUES (
                               v_order_row.WarehouseName,
                               v_product_id,
                               v_order_row.OrderQuantity,
                               TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'DD/MM/YYYY'),
                               TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'HH24:MI:SS'),
                               CASE
                                   WHEN v_new_quantity  <= 0 THEN 'Out of Stock'
                                   WHEN v_new_quantity < 10 THEN 'Low Stock'
                                   ELSE 'In Stock'
                                   END
                           )
                    ON CONFLICT (PID, WName) DO UPDATE SET
                                                           Quantity = Product_Warehouse.Quantity + EXCLUDED.Quantity,
                                                           LastUpdatedDate = TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'DD/MM/YYYY'),
                                                           LastUpdatedTime = TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'GMT+7', 'HH24:MI:SS'),
                                                           Status = CASE
                                                                        WHEN (Product_Warehouse.Quantity + EXCLUDED.Quantity) <= 0 THEN 'Out of Stock'
                                                                        WHEN (Product_Warehouse.Quantity + EXCLUDED.Quantity) < 10 THEN 'Low Stock'
                                                                        ELSE 'In Stock'
                                                               END;
                END IF;
            END LOOP;
    END $$;





---------FUNCTION TO GET TRIGGER
SELECT  event_object_table AS table_name ,trigger_name
FROM information_schema.triggers
GROUP BY table_name , trigger_name
ORDER BY table_name ,trigger_name ;
------------------------------------------------------------


INSERT INTO Type(TID,TName) VALUES (1,'Beverage');
INSERT INTO Type(TID,TName) VALUES (2,'Bakery');
INSERT INTO Type(TID,TName) VALUES (3,'Seasoning');
INSERT INTO Type(TID,TName) VALUES (4,'Dairy');
INSERT INTO Type(TID,TName) VALUES (5,'Frozen food');
INSERT INTO Type(TID,TName) VALUES (6,'Meat');
INSERT INTO Type(TID,TName) VALUES (7,'Vegetable');
INSERT INTO Type(TID,TName) VALUES (8,'Biscuit - Candy');
INSERT INTO Type(TID,TName) VALUES (9,'Cleaners');
INSERT INTO Type(TID,TName) VALUES (10,'Toilet stuffs');
INSERT INTO Type(TID,TName) VALUES (11,'Personal care');
INSERT INTO Type(TID,TName) VALUES (12,'Mom and baby');
INSERT INTO Type(TID,TName) VALUES (13,'Cereal');


---GET THE DATA FOR MONEY GRAPH IN MONTH
SELECT
    COALESCE(SUM(e.ExportQuantity * p.UnitPrice), 0) AS total_price
FROM
    (
        SELECT DISTINCT EXTRACT(MONTH FROM TO_DATE(d.Currentdate, 'DD-MM-YYYY')) AS month_number
        FROM Dim_date d
        WHERE EXTRACT(YEAR FROM TO_DATE(d.Currentdate, 'DD-MM-YYYY')) = EXTRACT(YEAR FROM CURRENT_DATE)
    ) months
        LEFT JOIN (
        SELECT
            e.ExportQuantity,
            e.PID,
            e.ExportDate,
            e.WName
        FROM
            Export_History e
        WHERE
            EXTRACT(YEAR FROM TO_DATE(e.ExportDate, 'DD-MM-YYYY')) = EXTRACT(YEAR FROM CURRENT_DATE)

    ) e ON EXTRACT(MONTH FROM TO_DATE(e.ExportDate, 'DD-MM-YYYY')) = months.month_number

        LEFT JOIN Product p ON p.PID = e.PID
GROUP BY
    months.month_number
ORDER BY
    months.month_number ASC;
--------------------------------------------------------------------
-- CREATE DATA FOR ORDER GRAPH IN DASHBOARD
SELECT
    COUNT(DISTINCT e.EID)
FROM
    Export_History e
        RIGHT JOIN
    Dim_date d ON EXTRACT(DAY FROM TO_DATE(e.ExportDate, 'DD-MM-YYYY')) = EXTRACT(DAY FROM TO_DATE(d.Currentdate, 'DD-MM-YYYY'))
        AND EXTRACT(MONTH FROM TO_DATE(e.ExportDate, 'DD-MM-YYYY')) = EXTRACT(MONTH FROM TO_DATE(d.Currentdate, 'DD-MM-YYYY'))
        AND EXTRACT(YEAR FROM TO_DATE(d.Currentdate, 'DD-MM-YYYY')) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY
    EXTRACT(MONTH FROM TO_DATE(d.Currentdate, 'DD-MM-YYYY'))
ORDER BY
    EXTRACT(MONTH FROM TO_DATE(d.Currentdate, 'DD-MM-YYYY')) ASC;

SELECT SupplierName , SupplierContact , SupplierAddress FROM Supplier;

----------------------------------------------------------------------

CREATE TABLE Warehouse_capacity(
                                   WName varchar(200),
                                   Wcapacity int not NULL,
                                   PRIMARY KEY(WName),
                                   FOREIGN KEY(WName) REFERENCES Warehouse(WName)
);

INSERT INTO Warehouse_capacity(WName ,  Wcapacity)
VALUES ('Warehouse1',  10000),
       ('Warehouse2', 15000);

select * from warehouse;

---------------------------------------------------QUERY TO CHANGE THE SERIAL AND RESET IT TO INITIAL ( START FROM 1 )
ALTER TABLE Export ALTER COLUMN EID DROP DEFAULT;

-- Then reset the sequence to start from 1
ALTER SEQUENCE export_eid_seq RESTART WITH 1;

-- Finally, set the default value of the EID column back to using the sequence
ALTER TABLE Export ALTER COLUMN EID SET DEFAULT nextval('export_eid_seq');



-- QUERY GET DATA FOR ACCOUNTINNG AND FREE SPACE FOR SPECIFIC WAREHOUSE

SELECT
    pw.WName,
    ((SUM(pw.Quantity::float) / wc.Wcapacity::float) * 100) AS Account_Space_Percentage,
    (100 - ((SUM(pw.Quantity::float) / wc.Wcapacity::float) * 100)) AS Free_Space_Percentage
FROM
    Product_Warehouse pw
        JOIN
    Warehouse_capacity wc
    ON
        pw.WName = wc.WName
WHERE
    pw.WName = 'Warehouse1'
GROUP BY
    pw.WName, wc.Wcapacity;


---------------------------------------------------------------------------------------------------------------
-- QUERY TO GET TOP 5 WHICH MOST EXPORTED
SELECT (e.ExportQuantity::float / total_sum.sum_quantity::float) * 100 AS Top_5, (100 -(e.ExportQuantity::float / total_sum.sum_quantity::float) * 100) AS Left_Stuff
FROM Export e, (SELECT SUM(ExportQuantity) AS sum_quantity FROM Export) AS total_sum;

------- AUTO INSERT TO ORDER_HISTORY TABLE
CREATE OR REPLACE FUNCTION insert_into_order_history()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO Order_History (PID, ProductName, SupplierName, WarehouseName, Order_Detail_ID, OrderDate, OrderQuantity, TotalCostPrice)
    VALUES (
               NEW.PID,
               NEW.ProductName,
               NEW.SupplierName,
               NEW.WarehouseName,
               NEW.Order_Detail_ID,
               NEW.OrderDate,
               NEW.OrderQuantity,
               NEW.OrderQuantity * (SELECT CostPrice FROM Product WHERE PID = NEW.PID)
           );

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER after_insert_order
    AFTER INSERT ON Product_Order
    FOR EACH ROW
EXECUTE FUNCTION insert_into_order_history();


TRUNCATE TABLE Product_Order;

DROP TRIGGER after_insert_order on Product_Order;
---------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT Product.PID , PName , Type.TName , Product.SupplierName , Product.CostPrice , Product.UnitPrice FROM Product INNER JOIN Product_Category ON Product.PID = Product_Category.PID INNER JOIN Type ON Product_Category.TID = Type.TID;

select * from product_category;
-----------------INSERT DATE FOR 1 YEAR AUTO TO DIM_DATE TABLE
CREATE OR REPLACE FUNCTION insert_next_year_dates() RETURNS void AS $$
DECLARE
    start_date DATE;
    end_date DATE;
BEGIN
    -- Set the start and end dates for the next year
    start_date := DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 year';
    end_date := start_date + INTERVAL '1 year' - INTERVAL '1 day';

    -- Insert all dates of the next year into the Dim_date table
    INSERT INTO Dim_date(Currentdate)
    SELECT TO_CHAR(d, 'DD-MM-YYYY')
    FROM generate_series(start_date, end_date, '1 day'::interval) AS d;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION check_and_insert_next_year_dates() RETURNS trigger AS $$
BEGIN
    IF TO_CHAR(CURRENT_DATE, 'DD-MM') = '31-12' THEN
        PERFORM insert_next_year_dates();
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Export(
                       WName varchar(200),
                       ProductName varchar(100),
                       SupplierName varchar(100),
                       EID serial,
                       ExportQuantity INTEGER CONSTRAINT positive_ExportQuantity CHECK (ExportQuantity > 0),
                       ExportDate varchar(200),
                       PRIMARY KEY(EID),
                       FOREIGN KEY (WName) REFERENCES Warehouse(WName)
);
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------- INSERT INTO EXPORT TABLE AND SUBTRACT THE EXPORT QUANTITY FROM PRODCUT_WAREHOUSE
INSERT INTO Export (WName, PID, ProductName, SupplierName, ExportQuantity, ExportDate)
VALUES (
           'Warehouse1',
           (SELECT p.PID FROM Product p WHERE p.PName = 'Warehouse1' AND p.SupplierName = 'Supplier2'),
           'Product2',
           'Supplier2',
           10,
           TO_CHAR(CURRENT_TIMESTAMP , 'DD/MM/YYYY')
       );
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WITH Needed_export_PID AS (
    SELECT Product.PID AS NeededPID
    FROM Product
    WHERE Product.Pname = <<INPUT_PRODUCT>> AND Product.SupplierName = <<INPUT_SUPPLIER>>
),
     Existing_Record AS (
         SELECT *
         FROM Product_Warehouse
         WHERE PID = (SELECT NeededPID FROM Needed_export_PID) AND WName = <<INPUT_WAREHOUSE>>
     )
-- Perform the update if conditions are met
UPDATE Product_Warehouse AS pw
SET
    Quantity = CASE
                   WHEN pw.Quantity >= <<INPUT_QUANTITY>>  THEN pw.Quantity - <<INPUT_QUANTITY>>
                   ELSE pw.Quantity  -- Do not change Quantity when insufficient
        END,
    Error_Message = CASE
                        WHEN  pw.Quantity < <<INPUT_QUANTITY>> THEN RAISE EXCEPTION 'Insufficient quantity for update'
                        ELSE NULL -- Reset error message if quantity is sufficient
        END,
    LastUpdatedDate = TO_CHAR(LOCALTIMESTAMP AT TIME ZONE 'GMT+7', 'DD/MM/YYYY'),
    LastUpdatedTime = TO_CHAR(LOCALTIMESTAMP AT TIME ZONE 'GMT+7', 'HH24:MI:SS'),
    Status = CASE
                 WHEN pw.Quantity - <<INPUT_QUANTITY>> = 0 THEN 'Out of Stock'
                 WHEN pw.Quantity - <<INPUT_QUANTITY>> < 10 THEN 'Low Stock'
                 ELSE 'In Stock'
        END
FROM Existing_Record er

WHERE pw.PID = er.PID AND pw.WName = <<INPUT_WAREHOUSE>>;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Dim_date (Currentdate)
SELECT TO_CHAR(d::date, 'DD-MM-YYYY')
FROM generate_series(
             date_trunc('year', CURRENT_DATE),
             date_trunc('year', CURRENT_DATE) + interval '1 year' - interval '1 day',
             interval '1 day'
     ) AS t(d);
CREATE TABLE Dim_date(Currentdate varchar(100));
truncate table product_order;
truncate table product_warehouse;
---------------------------------------------------------------------------------------------
WITH Needed_export_PID AS (
    SELECT Product.PID AS NeededPID
    FROM Product
    WHERE Product.Pname = 'Product2' AND Product.SupplierName = 'Supplier2'
),
     Existing_Record AS (
         SELECT *
         FROM Product_Warehouse
         WHERE PID = (SELECT NeededPID FROM Needed_export_PID) AND WName = 'Warehouse1'
     )
-- Perform the update if conditions are met
UPDATE Product_Warehouse AS pw
SET
    Quantity = CASE
                   WHEN pw.Quantity >= 5  THEN pw.Quantity - 5
                   ELSE pw.Quantity  -- Do not change Quantity when insufficient
        END,
    Error_Message = CASE
                        WHEN  pw.Quantity < 5 THEN 'Insufficient quantity for update'
                        ELSE NULL -- Reset error message if quantity is sufficient
        END,
    LastUpdatedDate = TO_CHAR(LOCALTIMESTAMP AT TIME ZONE 'GMT+7', 'DD/MM/YYYY'),
    LastUpdatedTime = TO_CHAR(LOCALTIMESTAMP AT TIME ZONE 'GMT+7', 'HH24:MI:SS'),
    Status = CASE
                 WHEN pw.Quantity - 5 = 0 THEN 'Out of Stock'
                 WHEN pw.Quantity - 5 < 10 THEN 'Low Stock'
                 ELSE 'In Stock'
        END
FROM Existing_Record er

WHERE pw.PID = er.PID AND pw.WName = 'Warehouse1';
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGER TO AUTO UPDATE THE SUPPLIER_NAME TO THE PRODUCT TABLE AFTER UPDATE THE SUPPLIERNAME ( EDIT THE SUPPLIER_NAME)
CREATE OR REPLACE FUNCTION update_supplier_name_in_product()
    RETURNS TRIGGER AS $$
BEGIN
    UPDATE Product
    SET SupplierName = NEW.SupplierName
    WHERE SID = NEW.SID;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER supplier_name_update
    AFTER UPDATE OF SupplierName ON Supplier
    FOR EACH ROW
EXECUTE FUNCTION update_supplier_name_in_product();
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DELETE PRODUCT
DELETE FROM product_warehouse
WHERE PID IN (SELECT PID FROM Product WHERE SupplierName = 'Supplier5') - 3 PID1 PID2 PID3

DELETE FROM product_order
WHERE PID IN (SELECT PID FROM Product WHERE SupplierName = 'Supplier5')

DELETE FROM product_category
WHERE PID IN (SELECT PID FROM Product WHERE SupplierName = 'Supplier5')


DELETE FROM PRODUCT
WHERE SupplierName = 'Supplier5'


DELETE FROM Supplier
WHERE SID = (SELECT SID FROM Supplier WHERE SupplierName = 'Supplier5');


SELECT PID FROM Product WHERE SupplierName = 'Supplier5';
SELECT SID FROM Supplier WHERE SupplierName = 'Supplier5';



