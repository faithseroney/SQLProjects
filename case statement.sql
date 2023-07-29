
/*This is a query to show my understanding of the CASE statement in sql that is used to 
query a database using certain conditions
*/

--Step 1: create table
CREATE TABLE EmployeesTable
(
EmployeeID INT Primary key,
Name Varchar(100),
Salary decimal (10,2)
)

--Step 2: Insert sample data
INSERT INTO EmployeesTable (EmployeeID, Name, Salary)
VALUES
    (1, 'John Doe', 55000.00),
    (2, 'Jane Smith', 32000.00),
    (3, 'Michael Johnson', 42000.00),
    (4, 'Emily Brown', 28000.00),
    (5, 'William Lee', 60000.00)

--Step 3: Query the data using CASE statement
--This query will return a third table that will return either high, medium or low for the salary condition met
SELECT
    EmployeeID,
    Name,
    Salary,
    CASE
        WHEN Salary >= 50000 THEN 'High'
        WHEN Salary >= 30000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryGrade
FROM EmployeesTable
