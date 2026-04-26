CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

CREATE TABLE Book ( BookID INT PRIMARY KEY, Title VARCHAR(100), Author VARCHAR(50),
    Publisher VARCHAR(50), AvailableCopies INT );

CREATE TABLE Member ( MemberID INT PRIMARY KEY, Name VARCHAR(50),
    Department VARCHAR(50), Phone VARCHAR(15) );

CREATE TABLE Issue ( IssueID INT PRIMARY KEY, BookID INT, MemberID INT, IssueDate DATE,
    ReturnDate DATE, FOREIGN KEY (BookID) REFERENCES Book(BookID),
     FOREIGN KEY (MemberID) REFERENCES Member(MemberID) );

CREATE TABLE Fine ( FineID INT PRIMARY KEY, IssueID INT, Amount DECIMAL(10,2),
    FOREIGN KEY (IssueID) REFERENCES Issue(IssueID) );

INSERT INTO Book VALUES (1,'DBMS','Korth','McGraw',5),
    (2,'OS','Galvin','Wiley',3),(3,'Java','Herbert','Oracle',4);

INSERT INTO Member VALUES (1,'Anu','CSE','1111111111'),
    (2,'Arun','ECE','2222222222'),(3,'Asha','EEE','3333333333');

INSERT INTO Issue VALUES (1,1,1,'2024-01-01','2024-01-10'), (2,2,2,'2024-01-05','2024-01-20'),
    (3,1,3,'2024-02-01',NULL), (4,3,1,'2024-02-10','2024-02-25');

INSERT INTO Fine VALUES (1,2,50),(2,4,20);

SELECT * FROM Book;

SELECT b.Title,m.Name,i.IssueDate,i.ReturnDate FROM Issue i JOIN Book b 
ON i.BookID=b.BookID JOIN Member m ON i.MemberID=m.MemberID;

SELECT * FROM Issue WHERE ReturnDate IS NOT NULL AND DATEDIFF(ReturnDate,IssueDate)>14;

SELECT SUM(Amount) FROM Fine;

SELECT * FROM Book WHERE AvailableCopies>0;

CREATE VIEW IssuedBooksView AS SELECT b.Title,m.Name,i.IssueDate FROM Issue i
JOIN Book b ON i.BookID=b.BookID JOIN Member m ON i.MemberID=m.MemberID;

DELIMITER //
CREATE TRIGGER issue_book
AFTER INSERT ON Issue
FOR EACH ROW
BEGIN
UPDATE Book SET AvailableCopies=AvailableCopies-1 WHERE BookID=NEW.BookID;
END //
DELIMITER ;

CREATE INDEX idx_title ON Book(Title);

SELECT BookID,COUNT(*) cnt, RANK() OVER (ORDER BY COUNT(*) DESC) rnk FROM Issue 
GROUP BY BookID;

SELECT b.Title,COUNT(*) cnt FROM Issue i JOIN Book b ON i.BookID=b.BookID
     GROUP BY i.BookID ORDER BY cnt DESC LIMIT 3;

SELECT MemberID,COUNT(*) FROM Issue GROUP BY MemberID;

SELECT * FROM Issue i1 WHERE IssueDate=(SELECT MAX(IssueDate) 
FROM Issue i2 WHERE i1.MemberID=i2.MemberID);

SELECT MemberID,COUNT(*) cnt FROM Issue GROUP BY MemberID HAVING COUNT(*)>2;

SELECT MemberID,COUNT(*) cnt,RANK() OVER (ORDER BY COUNT(*) DESC) rnk
FROM Issue GROUP BY MemberID;

SELECT BookID,MIN(IssueDate) FROM Issue GROUP BY BookID;

SELECT BookID,DATE_FORMAT(IssueDate,'%Y-%m') mth,COUNT(*)
FROM Issue GROUP BY BookID,mth HAVING COUNT(*)>1;

SELECT BookID,(COUNT(*)/(SELECT COUNT(*) FROM Issue))*100 AS Contribution
FROM Issue GROUP BY BookID;

SELECT IssueID,DATEDIFF(CURDATE(),IssueDate) overdue_days, RANK() 
OVER (ORDER BY DATEDIFF(CURDATE(),IssueDate) DESC) rnk FROM Issue WHERE ReturnDate IS NULL;

SELECT BookID,MAX(ReturnDate) FROM Issue GROUP BY BookID;

SELECT MemberID, COUNT(*) OVER (PARTITION BY MemberID ORDER BY IssueDate) trend FROM Issue;

SELECT BookID,AvailableCopies,DENSE_RANK() OVER (ORDER BY AvailableCopies DESC) drnk
FROM Book;