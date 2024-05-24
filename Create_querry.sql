CREATE TABLE Product (
                         PID varchar(100) PRIMARY KEY, -- sku
                         Pname varchar(100) NOT NULL, -- product name
                         SupplierName varchar(100),
                         SID int,
                         CostPrice decimal(5,2),
                         UnitPrice decimal(5,2),
                         FOREIGN KEY (SID) REFERENCES Supplier(SID)
);
CREATE TABLE Warehouse (
                           WName varchar(100) NOT NULL,
                           WAddress varchar(255) NOT NULL,
                           PRIMARY KEY(WName)
);
--------------------------------------------------------------
-- Create Supplier table (optional)
CREATE TABLE Supplier (
                          SID serial ,
                          SupplierName  varchar(100) NOT NULL,
                          SupplierContact varchar(255) NOT NULL,
                          SupplierAddress varchar(255) NOT NULL,
                          PRIMARY KEY (SID)
);

-- -------------QUERY TO EDIT THE SUPPLIER
-- UPDATE Supplier
-- SET
--     SupplierName = COALESCE('SUPPLIER_9_1', 'Supplier9'),
--     SupplierContact = COALESCE(NULL, 'contact9@example.com'),
--     SupplierAddress = COALESCE('Address_9_1', 'Address 9')
-- WHERE
--     SID = (SELECT SID FROM Supplier WHERE SupplierName = 'Supplier9');

--- CREATE TABLE ORDER_DETAIL
CREATE TABLE Order_Detail(
                             CodeOrder serial,
                             SupplierName varchar(200),
                             Order_Detail_Date varchar(200),
                             PRIMARY KEY (CodeOrder)
);




--------------------------------------------------------------------

-- Improved Inventory table (separated from Warehouse)
CREATE TABLE Product_Warehouse (

                                   WName varchar(200) ,
                                   PID varchar(100) ,
                                   Quantity int NOT NULL,
                                   LastUpdatedDate VARCHAR(200),
                                   LastUpdatedTime VARCHAR(200),
                                   Status varchar(100) ,
                                   FOREIGN KEY(WName) REFERENCES Warehouse(WName),
                                   FOREIGN KEY(PID) REFERENCES Product(PID),
                                   PRIMARY KEY (WName, PID)
);

SELECT pw.WName , p.PName , t.TName,p.UnitPrice , pw.Quantity, pw.Status FROM Product p INNER JOIN Product_Warehouse pw ON p.PID = pw.PID JOIN Product_Category pc ON pw.PID = pc.PID JOIN Type t  ON pc.TID = t.TID;
------------------------------------------------------------------------------
-- Create Order table
CREATE TABLE Product_Order (
                               OrderID serial ,
                               PID varchar(100),
                               ProductName varchar(100),
                               SupplierName varchar(100),
                               WarehouseName varchar(100),
                               Order_Detail_ID int,
                               FOREIGN KEY(WarehouseName) REFERENCES Warehouse(WName),
                               FOREIGN KEY(PID) REFERENCES Product(PID),
                               FOREIGN KEY (Order_Detail_ID) REFERENCES Order_Detail(CodeOrder),
                               OrderDate varchar(200),
                               OrderQuantity int CHECK (OrderQuantity >= 5 )
);






--------------------------------------------------------------------------------
-- CREATE TABLE HISTORY
CREATE TABLE Order_History(
                              OrderID serial ,
                              PID varchar(100),
                              ProductName varchar(100),
                              SupplierName varchar(100),
                              WarehouseName varchar(100),
                              Order_Detail_ID int,
                              OrderDate varchar(200),
                              OrderQuantity int,
                              TotalCostPrice decimal(5,2)
);




select * Order_History FROM Order_History  WHERE Order_Detail_ID = <<REFERENCE_ORDER_DETAIL_ID>>;



--------------------------------
CREATE TABLE Type (
                      TID int,
                      TName varchar (100),
                      PRIMARY KEY (TID)
);

---------------------------------

CREATE TABLE Product_Category (
                                  PID varchar(100) ,
                                  TID int ,
                                  FOREIGN KEY(PID) REFERENCES Product(PID),
                                  FOREIGN KEY (TID) REFERENCES Type(TID),
                                  PRIMARY KEY (PID)
);
CREATE TABLE Export(
                       WName varchar(200),
                       PID varchar(200),
                       ProductName varchar(100),
                       SupplierName varchar(100),
                       EID serial,
                       ExportQuantity INTEGER CONSTRAINT positive_ExportQuantity CHECK (ExportQuantity > 0),
                       ExportDate varchar(200),
                       EmployeeName varchar(100),
                       PRIMARY KEY(EID),
                       FOREIGN KEY (WName) REFERENCES Warehouse(WName)
);



CREATE TABLE Export_History(
                               PID varchar(100),
                               WName varchar(200),
                               ProductName varchar(100),
                               SupplierName varchar(100),
                               SID int,
                               EID int,
                               ExportQuantity int,
                               ExportDate varchar(200),
                               EmployeeName varchar(100)

);
CREATE TABLE Warehouse_capacity(
                                   WName varchar(200),
                                   Wcapacity int not NULL,
                                   PRIMARY KEY(WName),
                                   FOREIGN KEY(WName) REFERENCES Warehouse(WName)
);

CREATE TABLE Dim_date(Currentdate varchar(100));


