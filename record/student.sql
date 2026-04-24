CREATE TABLE Student (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Department VARCHAR(20),
    Marks INT
);

INSERT INTO Student VALUES
(1, 'Anu', 20, 'CSE', 85),
(2, 'Arun', 21, 'ECE', 78),
(3, 'Akhil', 20, 'CSE', 92),
(4, 'Meera', 22, 'EEE', 67),
(5, 'Asha', 19, 'CSE', 88);

-- Queries
SELECT * FROM Student;
SELECT Name, Marks FROM Student;
SELECT * FROM Student WHERE Marks > 80;
SELECT * FROM Student WHERE Department = 'CSE';
SELECT DISTINCT Department FROM Student;
SELECT * FROM Student WHERE Marks BETWEEN 60 AND 90;
SELECT * FROM Student WHERE Name LIKE 'A%';
SELECT * FROM Student WHERE Age != 20;
SELECT * FROM Student WHERE Department IN ('CSE','ECE');
SELECT * FROM Student WHERE Marks BETWEEN 70 AND 90;
SELECT COUNT(*) FROM Student;
SELECT AVG(Marks) FROM Student;
SELECT MAX(Marks), MIN(Marks) FROM Student;
SELECT Department, SUM(Marks) FROM Student GROUP BY Department;
SELECT Department, AVG(Marks) FROM Student GROUP BY Department;
SELECT Department FROM Student GROUP BY Department HAVING AVG(Marks) > 75;
SELECT Department, COUNT(*) FROM Student GROUP BY Department HAVING COUNT(*) > 2;
SELECT Department, COUNT(*) FROM Student GROUP BY Department;

-- Course Table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    StudentID INT,
    FOREIGN KEY (StudentID) REFERENCES Student(ID)
);

INSERT INTO Course VALUES
(101,'DBMS',1),
(102,'OS',2),
(103,'Java',3),
(104,'Networks',1);

-- Joins
SELECT * FROM Student s INNER JOIN Course c ON s.ID=c.StudentID;
SELECT * FROM Student s LEFT JOIN Course c ON s.ID=c.StudentID;
SELECT * FROM Student s RIGHT JOIN Course c ON s.ID=c.StudentID;

SELECT * FROM Student WHERE ID NOT IN (SELECT StudentID FROM Course);
SELECT s.Name,c.CourseName FROM Student s JOIN Course c ON s.ID=c.StudentID;

-- Subqueries
SELECT * FROM Student WHERE Marks > (SELECT AVG(Marks) FROM Student);
SELECT MAX(Marks) FROM Student WHERE Marks < (SELECT MAX(Marks) FROM Student);
SELECT * FROM Student WHERE Marks=(SELECT MAX(Marks) FROM Student);

SELECT Department,avg_marks FROM (SELECT Department,AVG(Marks) avg_marks FROM Student GROUP BY Department) t;

-- Constraints
CREATE TABLE Student2 (
    ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Email VARCHAR(50) UNIQUE,
    Age INT CHECK (Age>=18),
    Department VARCHAR(20) DEFAULT 'CSE'
);

-- EXISTS
SELECT Name FROM Student s WHERE EXISTS (SELECT 1 FROM Course c WHERE c.StudentID=s.ID);
SELECT Name FROM Student s WHERE NOT EXISTS (SELECT 1 FROM Course c WHERE c.StudentID=s.ID);

-- View
CREATE VIEW HighMarks AS SELECT * FROM Student WHERE Marks>75;
UPDATE HighMarks SET Marks=90 WHERE ID=2;
DROP VIEW HighMarks;

-- Index
CREATE INDEX idx_name ON Student(Name);

-- Stored Procedure
DELIMITER //
CREATE PROCEDURE GetStudents()
BEGIN
SELECT * FROM Student;
END //
DELIMITER ;

-- 5th highest
SELECT DISTINCT Marks FROM Student s1
WHERE 4=(SELECT COUNT(DISTINCT Marks) FROM Student s2 WHERE s2.Marks>s1.Marks);

-- Duplicates
SELECT Name,COUNT(*) FROM Student GROUP BY Name HAVING COUNT(*)>1;

DELETE FROM Student WHERE ID NOT IN (SELECT MIN(ID) FROM (SELECT * FROM Student) t GROUP BY Name);

-- Ranking
SELECT Name,Marks,RANK() OVER (ORDER BY Marks DESC) Rank FROM Student;

-- Cumulative
SELECT Name,Marks,SUM(Marks) OVER (ORDER BY ID) CumSum FROM Student;

-- Function
DELIMITER //
CREATE FUNCTION GetGrade(m INT)
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
DECLARE g VARCHAR(2);
IF m>=90 THEN SET g='A';
ELSEIF m>=75 THEN SET g='B';
ELSE SET g='C';
END IF;
RETURN g;
END //
DELIMITER ;

-- Trigger
CREATE TABLE LogTable(msg VARCHAR(100));

DELIMITER //
CREATE TRIGGER trg_after_insert
AFTER INSERT ON Student
FOR EACH ROW
BEGIN
INSERT INTO LogTable VALUES(CONCAT('Inserted ID: ',NEW.ID));
END //
DELIMITER ;