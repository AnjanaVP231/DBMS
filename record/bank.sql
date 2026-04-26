CREATE DATABASE IF NOT EXISTS bank_db;
USE bank_db;

CREATE TABLE Customer ( CustomerID INT PRIMARY KEY, Name VARCHAR(50),
    Address VARCHAR(100), Phone VARCHAR(15) );

CREATE TABLE Branch (BranchID INT PRIMARY KEY, BranchName VARCHAR(50),
    Location VARCHAR(50) );

CREATE TABLE Account ( AccountID INT PRIMARY KEY, CustomerID INT,
    BranchID INT, Balance DECIMAL(10,2), AccountType VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID) );

CREATE TABLE Transaction ( TransactionID INT PRIMARY KEY, AccountID INT,
    Amount DECIMAL(10,2), Type VARCHAR(20), Date DATE,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID) );

INSERT INTO Customer VALUES (1,'Anu','Kochi','1111111111'),
(2,'Arun','TVM','2222222222'),(3,'Asha','Kozhikode','3333333333');

INSERT INTO Branch VALUES(1,'SBI Kochi','Kochi'),(2,'SBI TVM','TVM');

INSERT INTO Account VALUES (101,1,1,5000,'Savings'),(102,1,1,8000,'Current'),
(103,2,2,12000,'Savings'),(104,3,2,3000,'Savings');

INSERT INTO Transaction VALUES (1,101,2000,'Deposit','2024-01-01'),
(2,101,1000,'Withdrawal','2024-01-02'),(3,102,3000,'Deposit','2024-01-03'),
(4,103,5000,'Deposit','2024-01-04'),(5,103,2000,'Withdrawal','2024-01-05');

SELECT * FROM Account;

SELECT c.Name,a.AccountID,a.Balance,a.AccountType
FROM Customer c JOIN Account a ON c.CustomerID=a.CustomerID;

SELECT * FROM Transaction;

SELECT b.BranchName,SUM(a.Balance) FROM Account a JOIN Branch b 
ON a.BranchID=b.BranchID GROUP BY b.BranchName;

SELECT * FROM Transaction WHERE Amount>3000;

CREATE VIEW CustomerAccountView AS SELECT c.Name,a.AccountID,a.Balance
FROM Customer c JOIN Account a ON c.CustomerID=a.CustomerID;

CREATE INDEX index_acc_id ON Account(AccountID);

DELIMITER //
CREATE TRIGGER UpdateBalance
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
IF NEW.Type='Deposit' THEN
UPDATE Account SET Balance=Balance+NEW.Amount WHERE AccountID=NEW.AccountID;
ELSEIF NEW.Type='Withdrawal' THEN
UPDATE Account SET Balance=Balance-NEW.Amount WHERE AccountID=NEW.AccountID;
END IF;
END //
DELIMITER ;

SELECT c.Name,SUM(a.Balance) TotalBalance FROM Customer c JOIN Account a 
ON c.CustomerID=a.CustomerID GROUP BY c.Name ORDER BY TotalBalance DESC LIMIT 3;

SELECT t.AccountID,t.Date,t.Amount, SUM(t.Amount) OVER (PARTITION BY t.AccountID ORDER BY t.Date) 
RunningBalance FROM Transaction t;

SELECT * FROM Account WHERE AccountID NOT IN (SELECT AccountID FROM Transaction);

SELECT * FROM Transaction WHERE Amount>5000;

SELECT DATE_FORMAT(Date,'%Y-%m') Month,SUM(Amount) FROM Transaction GROUP BY Month;

SELECT CustomerID,COUNT(AccountID) FROM Account GROUP BY CustomerID HAVING COUNT(AccountID)>1;

SELECT MAX(Balance) FROM Account WHERE Balance < (SELECT MAX(Balance) FROM Account);

SELECT AccountID,Balance, RANK() OVER (ORDER BY Balance DESC) rnk FROM Account;

SELECT BranchID,AVG(Balance) FROM Account GROUP BY BranchID;

SELECT c.Name FROM Customer c WHERE c.CustomerID NOT IN 
( SELECT a.CustomerID FROM Account a JOIN Transaction t ON a.AccountID=t.AccountID
    WHERE t.Type='Withdrawal' );

SELECT AccountID,COUNT(*) FROM Transaction GROUP BY AccountID;

SELECT * FROM Transaction t1
WHERE Date=(SELECT MAX(Date) FROM Transaction t2 WHERE t1.AccountID=t2.AccountID);

SELECT * FROM Account WHERE Balance<2000;

SELECT AccountID, (Balance/(SELECT SUM(Balance) FROM Account))*100 AS Percentage FROM Account;

SELECT * FROM Transaction WHERE Type='Withdrawal' AND Amount>4000;