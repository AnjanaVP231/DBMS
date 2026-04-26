CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

CREATE TABLE Customer ( CustomerID INT PRIMARY KEY, Name VARCHAR(50),
    Email VARCHAR(50), Phone VARCHAR(15) );

CREATE TABLE Product ( ProductID INT PRIMARY KEY, ProductName VARCHAR(50),
    Price DECIMAL(10,2), Stock INT );

CREATE TABLE Orders ( OrderID INT PRIMARY KEY, CustomerID INT, OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) );

CREATE TABLE OrderDetails ( OrderID INT,ProductID INT,Quantity INT,
    PRIMARY KEY (OrderID, ProductID),FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) );

CREATE TABLE Payment (PaymentID INT PRIMARY KEY, OrderID INT,Amount DECIMAL(10,2),
    Status VARCHAR(20), FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) );

INSERT INTO Customer VALUES (1,'Anu','anu@gmail.com','1111111111'),
    (2,'Arun','arun@gmail.com','2222222222');

INSERT INTO Product VALUES 
    (101,'Laptop',50000,10), (102,'Phone',20000,5),(103,'Tablet',15000,2);

INSERT INTO Orders VALUES (1,1,'2024-01-01'),(2,2,'2024-01-02');

INSERT INTO OrderDetails VALUES (1,101,1),(1,102,2),(2,103,1);

INSERT INTO Payment VALUES (1,1,90000,'Paid'),(2,2,15000,'Pending');

SELECT * FROM Product;

SELECT c.Name,o.OrderID,p.ProductName,od.Quantity FROM Customer c
JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN OrderDetails od ON o.OrderID=od.OrderID
JOIN Product p ON od.ProductID=p.ProductID;

SELECT c.Name,SUM(p.Price*od.Quantity) AS TotalAmount FROM Customer c
JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN OrderDetails od ON o.OrderID=od.OrderID
JOIN Product p ON od.ProductID=p.ProductID GROUP BY c.Name;

SELECT * FROM Product WHERE Stock<5;

SELECT * FROM Orders o JOIN Payment p ON o.OrderID=p.OrderID WHERE p.Status='Paid';

CREATE VIEW CustomerOrderSummary AS
SELECT c.Name,o.OrderID,p.ProductName,od.Quantity,p.Price FROM Customer c
JOIN Orders o ON c.CustomerID=o.CustomerID
JOIN OrderDetails od ON o.OrderID=od.OrderID
JOIN Product p ON od.ProductID=p.ProductID;

DELIMITER //
CREATE TRIGGER reduce_stock
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
UPDATE Product
SET Stock=Stock-NEW.Quantity
WHERE ProductID=NEW.ProductID;
END //
DELIMITER ;

CREATE INDEX idx_product_name ON Product(ProductName);