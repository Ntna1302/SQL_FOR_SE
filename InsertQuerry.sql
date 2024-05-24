--INSERT DATA
-- Insert data into Supplier table
INSERT INTO Supplier (SupplierName, SupplierContact, SupplierAddress)
VALUES
    ('Supplier1', 'contact1@example.com', 'Address 1'),
    ('Supplier2', 'contact2@example.com', 'Address 2'),
    ('Supplier3', 'contact3@example.com', 'Address 3'),
    ('Supplier4', 'contact4@example.com', 'Address 4'),
    ('Supplier5', 'contact5@example.com', 'Address 5'),
    ('Supplier6', 'contact6@example.com', 'Address 6'),
    ('Supplier7', 'contact7@example.com', 'Address 7'),
    ('Supplier8', 'contact8@example.com', 'Address 8'),
    ('Supplier9', 'contact9@example.com', 'Address 9'),
    ('Supplier10', 'contact10@example.com', 'Address 10');

-- Insert data into Product table
INSERT INTO Product (PID, Pname, SupplierName, SID, CostPrice, UnitPrice)
VALUES
    ('P001', 'Product1', 'Supplier1', 1, 10.00, 15.00),
    ('P002', 'Product2', 'Supplier1', 1, 12.00, 18.00),
    ('P003', 'Product3', 'Supplier2', 2, 15.00, 22.00),
    ('P004', 'Product4', 'Supplier2', 2, 9.00, 14.00),
    ('P005', 'Product5', 'Supplier3', 3, 8.00, 12.00),
    ('P006', 'Product6', 'Supplier3', 3, 7.50, 11.50),
    ('P007', 'Product7', 'Supplier4', 4, 11.00, 16.00),
    ('P008', 'Product8', 'Supplier4', 4, 6.50, 10.00),
    ('P009', 'Product9', 'Supplier5', 5, 20.00, 30.00),
    ('P010', 'Product10', 'Supplier5', 5, 18.00, 27.00),
    ('P011', 'Product11', 'Supplier6', 6, 14.00, 21.00),
    ('P012', 'Product12', 'Supplier6', 6, 13.00, 19.00),
    ('P013', 'Product13', 'Supplier7', 7, 5.00, 7.50),
    ('P014', 'Product14', 'Supplier7', 7, 22.00, 35.00),
    ('P015', 'Product15', 'Supplier8', 8, 9.50, 14.50),
    ('P016', 'Product16', 'Supplier8', 8, 10.00, 15.00),
    ('P017', 'Product17', 'Supplier9', 9, 25.00, 37.50),
    ('P018', 'Product18', 'Supplier9', 9, 23.00, 34.50),
    ('P019', 'Product19', 'Supplier10', 10, 12.00, 18.00),
    ('P020', 'Product20', 'Supplier10', 10, 16.00, 24.00);


INSERT INTO Product (PID, Pname, SupplierName, SID, CostPrice, UnitPrice)
VALUES
    (<<INPUT_SKU>>, <<INPUT_PRODUCT_NAME>>, <<INPUT_SUPPLIER>>, (SELECT SID FROM Supplier WHERE SupplierName = <<INPUT_SUPPLIER>>, <<INPUT_COST_PRICE>>, <<INPUT_UNIT_PRICE>>),


-- Insert data into Warehouse table
INSERT INTO Warehouse (WName, WAddress)
VALUES
    ('Warehouse1', '123 Warehouse St, City, Country'),
    ('Warehouse2', '456 Storage Ave, City, Country');


-- INSERT INTO Order_Detail table
INSERT INTO Order_Detail (SupplierName, Order_Detail_Date)
VALUES
    ('Supplier1', '2024-05-01'),
    ('Supplier2', '2024-05-02'),
    ('Supplier3', '2024-05-03'),
    ('Supplier4', '2024-05-04'),
    ('Supplier5', '2024-05-05'),
    ('Supplier6', '2024-05-06'),
    ('Supplier7', '2024-05-07'),
    ('Supplier8', '2024-05-08'),
    ('Supplier9', '2024-05-09'),
    ('Supplier10', '2024-05-10');


ALTER SEQUENCE order_detail_codeorder_seq RESTART WITH 1;

-------------INSERT INTO PRODUCT_CATEGORY TABLE
-- Insert data into Product_Category table



-- Insert data into Product_Order table
INSERT INTO Product_Order (PID, ProductName, SupplierName, WarehouseName, Order_Detail_ID, OrderDate, OrderQuantity)
VALUES
('P001', 'Product1', 'Supplier1', 'Warehouse1', 1, TO_CHAR(TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 5),
('P002', 'Product2', 'Supplier1', 'Warehouse1', 1, TO_CHAR(TO_DATE('2024-05-02', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 10),
('P003', 'Product3', 'Supplier2', 'Warehouse1', 2, TO_CHAR(TO_DATE('2024-05-03', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 7),
('P004', 'Product4', 'Supplier2', 'Warehouse1', 2, TO_CHAR(TO_DATE('2024-05-04', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 6),
('P005', 'Product5', 'Supplier3', 'Warehouse1', 3, TO_CHAR(TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 8),
('P006', 'Product6', 'Supplier3', 'Warehouse1', 3, TO_CHAR(TO_DATE('2024-05-06', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 12),
('P007', 'Product7', 'Supplier4', 'Warehouse1', 4, TO_CHAR(TO_DATE('2024-05-07', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 9),
('P008', 'Product8', 'Supplier4', 'Warehouse1', 4, TO_CHAR(TO_DATE('2024-05-08', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 5),
('P009', 'Product9', 'Supplier5', 'Warehouse1', 5, TO_CHAR(TO_DATE('2024-05-09', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 6),
('P010', 'Product10', 'Supplier5', 'Warehouse1', 5, TO_CHAR(TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 10),
('P011', 'Product11', 'Supplier6', 'Warehouse2', 6, TO_CHAR(TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 11),
('P012', 'Product12', 'Supplier6', 'Warehouse2', 6, TO_CHAR(TO_DATE('2024-05-12', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 7),
('P013', 'Product13', 'Supplier7', 'Warehouse2', 7, TO_CHAR(TO_DATE('2024-05-13', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 8),
('P014', 'Product14', 'Supplier7', 'Warehouse2', 7, TO_CHAR(TO_DATE('2024-05-14', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 6),
('P015', 'Product15', 'Supplier8', 'Warehouse2', 8, TO_CHAR(TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 9),
('P016', 'Product16', 'Supplier8', 'Warehouse2', 8, TO_CHAR(TO_DATE('2024-05-16', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 12),
('P017', 'Product17', 'Supplier9', 'Warehouse2', 9, TO_CHAR(TO_DATE('2024-05-17', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 15),
('P018', 'Product18', 'Supplier9', 'Warehouse2', 9, TO_CHAR(TO_DATE('2024-05-18', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 20),
('P019', 'Product19', 'Supplier10', 'Warehouse2', 10, TO_CHAR(TO_DATE('2024-05-19', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 25),
('P020', 'Product20', 'Supplier10', 'Warehouse2', 10, TO_CHAR(TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'DD-MM-YYYY'), 30);





-- Insert data into Export table
INSERT INTO Export (WName, PID, ProductName, SupplierName, ExportQuantity, ExportDate)
VALUES
    ('Warehouse1', 'P001', 'Product1', 'Supplier1', 3, TO_CHAR(TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'DD-MM-YYYY')  ),
    ('Warehouse1', 'P002', 'Product2', 'Supplier1', 5, TO_CHAR(TO_DATE('2024-05-02', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P003', 'Product3', 'Supplier2', 6, TO_CHAR(TO_DATE('2024-05-03', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P004', 'Product4', 'Supplier2', 4, TO_CHAR(TO_DATE('2024-05-04', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P005', 'Product5', 'Supplier3', 7, TO_CHAR(TO_DATE('2024-05-05', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P006', 'Product6', 'Supplier3', 2, TO_CHAR(TO_DATE('2024-05-06', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P007', 'Product7', 'Supplier4', 1, TO_CHAR(TO_DATE('2024-05-07', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P008', 'Product8', 'Supplier4', 5, TO_CHAR(TO_DATE('2024-05-08', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P009', 'Product9', 'Supplier5', 8, TO_CHAR(TO_DATE('2024-05-09', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse1', 'P010', 'Product10', 'Supplier5', 3, TO_CHAR(TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P011', 'Product11', 'Supplier6', 7, TO_CHAR(TO_DATE('2024-05-11', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P012', 'Product12', 'Supplier6', 4, TO_CHAR(TO_DATE('2024-05-12', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P013', 'Product13', 'Supplier7', 6, TO_CHAR(TO_DATE('2024-05-13', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P014', 'Product14', 'Supplier7', 3, TO_CHAR(TO_DATE('2024-05-14', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P015', 'Product15', 'Supplier8', 2, TO_CHAR(TO_DATE('2024-05-15', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P016', 'Product16', 'Supplier8', 5, TO_CHAR(TO_DATE('2024-05-16', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P017', 'Product17', 'Supplier9', 1, TO_CHAR(TO_DATE('2024-05-17', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P018', 'Product18', 'Supplier9', 8, TO_CHAR(TO_DATE('2024-05-18', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P019', 'Product19', 'Supplier10', 6, TO_CHAR(TO_DATE('2024-05-19', 'YYYY-MM-DD'), 'DD-MM-YYYY')),
    ('Warehouse2', 'P020', 'Product20', 'Supplier10', 9, TO_CHAR(TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'DD-MM-YYYY'));




-- Insert data into Product_Category table
-- Insert data into Product_Category table
INSERT INTO Product_Category (PID, TID)
VALUES
    ('P001', 1), -- Product1 is associated with TID 1 (Beverage)
    ('P002', 1), -- Product2 is associated with TID 1 (Beverage)
    ('P003', 2), -- Product3 is associated with TID 2 (Bakery)
    ('P004', 2), -- Product4 is associated with TID 2 (Bakery)
    ('P005', 3), -- Product5 is associated with TID 3 (Seasoning)
    ('P006', 3), -- Product6 is associated with TID 3 (Seasoning)
    ('P007', 4), -- Product7 is associated with TID 4 (Dairy)
    ('P008', 4), -- Product8 is associated with TID 4 (Dairy)
    ('P009', 5), -- Product9 is associated with TID 5 (Frozen food)
    ('P010', 5), -- Product10 is associated with TID 5 (Frozen food)
    ('P011', 6), -- Product11 is associated with TID 6 (Meat)
    ('P012', 6), -- Product12 is associated with TID 6 (Meat)
    ('P013', 7), -- Product13 is associated with TID 7 (Vegetable)
    ('P014', 7), -- Product14 is associated with TID 7 (Vegetable)
    ('P015', 8), -- Product15 is associated with TID 8 (Biscuit - Candy)
    ('P016', 8), -- Product16 is associated with TID 8 (Biscuit - Candy)
    ('P017', 9), -- Product17 is associated with TID 9 (Cleaners)
    ('P018', 9), -- Product18 is associated with TID 9 (Cleaners)
    ('P019', 10), -- Product19 is associated with TID 10 (Toilet stuffs)
    ('P020', 10); -- Product20 is associated with TID 10 (Toilet stuffs)


-----------------------



-- INSERT INTO PRODUCT_WAREHOUSE
-------------------------------------------------------------
INSERT INTO Product_Order(PID, ProductName, SupplierName, WarehouseName, Order_Detail_ID, OrderDate, OrderQuantity)
WITH Needed_PID AS (
    SELECT Product.PID AS NeededPID
    FROM Product
    WHERE Product.Pname = 'Product1' AND Product.SupplierName = 'Supplier1'
)
SELECT Needed_PID.NeededPID, 'Product1', 'Supplier1', 'Warehouse1', (
    SELECT Order_Detail.CodeOrder
    FROM Order_Detail
    ORDER BY CodeOrder DESC LIMIT 1
), CURRENT_TIMESTAMP, 5
FROM Needed_PID;


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


INSERT INTO Warehouse_capacity(WName ,  Wcapacity)
VALUES ('Warehouse1',  10000),
       ('Warehouse2', 15000);