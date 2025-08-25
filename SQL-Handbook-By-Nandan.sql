/*
========================================================
          MYSQL COMPLETE HANDBOOK & PRACTICE NOTES
          Author: Nandan S
          Purpose: Learning + Professional Reference
          Level: Beginner → Advanced (Pro)
========================================================
*/

/*------------------------------------------------------
  SECTION 1: DATABASE BASICS
------------------------------------------------------
Definition:
- A Database is a collection of structured data.
- In MySQL, we create databases to logically organize tables.
------------------------------------------------------*/

-- Create a new database
CREATE DATABASE company_db;

-- Use a database
USE company_db;

-- Drop a database
DROP DATABASE IF EXISTS old_db;


/*------------------------------------------------------
  SECTION 2: TABLE BASICS
------------------------------------------------------
Definition:
- Tables store data in rows and columns.
- Each table should have a PRIMARY KEY (unique identifier).
------------------------------------------------------*/

-- Create a simple table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE
);

-- Insert values (Example with my name "Nandan S")
INSERT INTO employees (emp_name, department, salary, hire_date)
VALUES 
('Alice', 'HR', 55000, '2023-01-15'),
('Bob', 'IT', 75000, '2022-06-10'),
('Nandan S', 'Full Stack', 90000, '2025-01-01');

-- Update records
UPDATE employees SET salary = salary + 5000 WHERE department = 'HR';

-- Delete records
DELETE FROM employees WHERE emp_name = 'Alice';

-- Select all employees
SELECT * FROM employees;


/*------------------------------------------------------
  SECTION 3: FILTERING DATA
------------------------------------------------------
Definition:
- The WHERE clause filters rows.
- Logical operators: AND, OR, NOT.
- Pattern search: LIKE, IN, BETWEEN.
- NULL checks: IS NULL / IS NOT NULL.
------------------------------------------------------*/

SELECT * FROM employees 
WHERE department = 'IT' AND salary > 60000;

SELECT * FROM employees WHERE department IN ('IT', 'HR');
SELECT * FROM employees WHERE salary BETWEEN 50000 AND 80000;
SELECT * FROM employees WHERE emp_name LIKE 'N%'; -- Finds "Nandan S"


/*------------------------------------------------------
  SECTION 4: SQL FUNCTIONS
------------------------------------------------------
Definition:
- Functions are pre-built operations in MySQL.
- Types: Numeric, String, Date, Control Flow.
------------------------------------------------------*/

-- Numeric Functions
SELECT ABS(-10), ROUND(235.756, 2), CEIL(4.2), FLOOR(4.8);

-- String Functions
SELECT UPPER(emp_name), LOWER(emp_name), LENGTH(emp_name), 
       CONCAT(emp_name, ' works in ', department)
FROM employees;

-- Date Functions
SELECT NOW(), CURDATE(), YEAR(hire_date), MONTHNAME(hire_date) FROM employees;

-- Control Flow
SELECT emp_name,
       IF(salary > 70000, 'High', 'Medium') AS salary_band
FROM employees;


/*------------------------------------------------------
  SECTION 5: JOINS
------------------------------------------------------
Definition:
- Joins combine data from multiple tables.
- INNER JOIN: Matching records only.
- LEFT JOIN: All left + matching right.
- RIGHT JOIN: All right + matching left.
- SELF JOIN: Join table to itself.
------------------------------------------------------*/

-- Example: INNER JOIN
SELECT e.emp_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department = d.department_id;


/*------------------------------------------------------
  SECTION 6: UNION, GROUP BY, HAVING
------------------------------------------------------
Definition:
- UNION: Combines results of multiple queries.
- GROUP BY: Groups rows for aggregation.
- HAVING: Filters groups (like WHERE for aggregates).
------------------------------------------------------*/

SELECT department, COUNT(*) AS emp_count, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 60000;


/*------------------------------------------------------
  SECTION 7: SUBQUERIES
------------------------------------------------------
Definition:
- Subqueries are queries inside queries.
- Used for filtering, comparison, or generating results.
- Can be simple or correlated.
------------------------------------------------------*/

-- Employees earning above average salary
SELECT emp_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);


/*------------------------------------------------------
  SECTION 8: VIEWS
------------------------------------------------------
Definition:
- A View is a virtual table created from a query.
- Used for simplifying queries & security.
------------------------------------------------------*/

CREATE VIEW high_salary_employees AS
SELECT emp_name, department, salary
FROM employees
WHERE salary > 70000;

SELECT * FROM high_salary_employees;


/*------------------------------------------------------
  SECTION 9: CONSTRAINTS & ALTER
------------------------------------------------------
Definition:
- Constraints enforce rules on data (PRIMARY KEY, UNIQUE, CHECK, FOREIGN KEY).
- ALTER TABLE modifies an existing table.
------------------------------------------------------*/

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT CHECK (age >= 18)
);


/*------------------------------------------------------
  SECTION 10: INDEXES
------------------------------------------------------
Definition:
- Indexes speed up queries.
- BUT, too many indexes slow down INSERT/UPDATE.
------------------------------------------------------*/

CREATE INDEX idx_emp_name ON employees(emp_name);


/*------------------------------------------------------
  SECTION 11: TRANSACTIONS
------------------------------------------------------
Definition:
- A Transaction is a sequence of operations performed as a single unit.
- Properties: ACID
  A → Atomicity (all or nothing)
  C → Consistency (valid state maintained)
  I → Isolation (transactions don’t conflict)
  D → Durability (committed data is permanent)
------------------------------------------------------*/

START TRANSACTION;

UPDATE employees SET salary = salary + 1000 WHERE department = 'IT';
DELETE FROM employees WHERE emp_name = 'Bob';

-- ROLLBACK cancels transaction
ROLLBACK;

-- COMMIT permanently saves changes
COMMIT;


/*------------------------------------------------------
  SECTION 12: STORED PROCEDURES & FUNCTIONS
------------------------------------------------------
Definition:
- Stored Procedure: Saved SQL code that can be reused.
- Function: Returns a value and can be used inside queries.
------------------------------------------------------*/

DELIMITER //
CREATE PROCEDURE GetHighSalaryEmployees()
BEGIN
    SELECT emp_name, salary
    FROM employees
    WHERE salary > 70000;
END //
DELIMITER ;

CALL GetHighSalaryEmployees();

DELIMITER //
CREATE FUNCTION BonusCalculator(base_salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN base_salary * 0.10;
END //
DELIMITER ;

SELECT emp_name, BonusCalculator(salary) AS bonus FROM employees;


/*------------------------------------------------------
  SECTION 13: TRIGGERS
------------------------------------------------------
Definition:
- A Trigger automatically executes when an event (INSERT, UPDATE, DELETE) occurs.
- Used for auditing, validation, or automatic updates.
------------------------------------------------------*/

DELIMITER //
CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SET NEW.salary = 0;
    END IF;
END //
DELIMITER ;


/*------------------------------------------------------
  SECTION 14: ADVANCED TOPICS
------------------------------------------------------
Definition:
- Window Functions: Perform calculations across sets of rows.
- CTE (Common Table Expressions): Temporary result sets.
------------------------------------------------------*/

-- Window Function
SELECT emp_name, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_dept
FROM employees;

-- CTE
WITH dept_avg AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
)
SELECT e.emp_name, e.salary, d.avg_salary
FROM employees e
JOIN dept_avg d ON e.department = d.department;


/*
========================================================
 END OF PROFESSIONAL SQL HANDBOOK
 Author: Nandan S
========================================================
*/
