# Library Management System Using SQL

## Project Overview

**Project Title**: Library Management System
**Database**: `library_db`

This project demonstrates the implementation of a library management system using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library-Management-System](https://github.com/kathy254/Library-Management-System/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/kathy254/Library-Management-System/blob/main/Library%20management%20ERD.png)

- **Database Creation**: Create a database named `library_db`
- **Table Creation**: Create tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

-- Create branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch
 (
	branch_id VARCHAR(10) PRIMARY KEY,
	manager_id VARCHAR(10),
	branch_address VARCHAR(50),
	contact_no VARCHAR(50)
);

-- Create employees table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(75),
	position VARCHAR(50),
	salary FLOAT,
	branch_id VARCHAR(10) --FK
);

DROP TABLE IF EXISTS books;
CREATE TABLE books
	(
		isbn VARCHAR(25) PRIMARY KEY,
		book_title VARCHAR(100),
		category VARCHAR(50),
		rental_price FLOAT,
		status VARCHAR(10),
		author VARCHAR(50),
		publisher VARCHAR(75)
	);

DROP TABLE IF EXISTS members;
CREATE TABLE members
	(
		member_id VARCHAR(25) PRIMARY KEY,
		member_name VARCHAR(50),
		member_address VARCHAR(25),
		reg_date DATE
	);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
	(
  	issued_id VARCHAR(25) PRIMARY KEY,
  	issued_member_id VARCHAR(25), --FK
  	issued_book_name VARCHAR(100), 
  	issued_date DATE,
  	issued_book_isbn VARCHAR(25), --FK
  	issued_emp_id VARCHAR(25) --FK
	);

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
	(
		return_id VARCHAR(25) PRIMARY KEY,
		issued_id VARCHAR(25), --FK
		return_book_name VARCHAR(100),
		return_date DATE,
		return_book_isbn VARCHAR(25) --FK
	);

-- Add foreign key constraints
ALTER TABLE issued_status
ADD CONSTRAINT member_fkey
FOREIGN KEY (issued_member_id) REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT book_isbn_fkey
FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT employee_fkey
FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT branch_fkey
FOREIGN KEY (branch_id) REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT issue_id_fkey
FOREIGN KEY (issued_id) REFERENCES issued_status(issued_id);

ALTER TABLE return_status
ADD CONSTRAINT return_isbn_fkey
FOREIGN KEY (return_book_isbn) REFERENCES books(isbn);
```
### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from the various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the members table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM books;
```

**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

```sql
SELECT issued_book_name
FROM issued_status
WHERE issued_emp_id = 'E101';
```

**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT
	issued_emp_id,
	COUNT(*) AS book_number
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1;
```

### 3. CTAS (Create Table As Select)
**Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issued_cnt AS
SELECT 	
	b.book_title,
	COUNT(*) AS issued_times
FROM books b
JOIN issued_status i
ON b.isbn = i.issued_book_isbn
GROUP BY b.book_title;

SELECT * FROM book_issued_cnt;
```

### 4. Data Analysis and Findings
The following SQL queries were used to address specific questions:

**Task 7. Retrieve All Books in a Specific Category**

```sql
SELECT * 
FROM books
WHERE category = 'Classic';
```

**Task 8: Find Total Rental Income by Category**

```sql
SELECT
	b.category,
	SUM(b.rental_price) AS total_rental_income,
	COUNT(*) AS times_rented
FROM books b
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;
```

**Task 9: List Members Who Registered in November 2021**

```sql
SELECT
	*
FROM members
WHERE TO_CHAR(reg_date, 'YYYY-MM') = '2021-11';
```

**Task 10: List Employees with Their Branch Manager's Name and their branch details**

```sql
SELECT
	e1.emp_id,
	e1.emp_name,
	e2.emp_name AS manager,
	b.branch_id,
	b.manager_id
FROM employees AS e1
JOIN branch AS b
ON e1.branch_id = b.branch_id
JOIN employees AS e2
ON b.manager_id = e2.emp_id;
```

**Task 11. Create a Table of Books with Rental Price Above 7 USD**

```sql
CREATE TABLE book_rental_price AS
SELECT
	book_title,
	rental_price
FROM books
WHERE rental_price > 7;

SELECT * FROM book_rental_price;
```
**Task 12: Retrieve the List of Books not yet Returned**

```sql
SELECT DISTINCT ist.issued_book_name 
FROM issued_status ist
LEFT JOIN return_status rs
ON ist.issued_id = rs.issued_id
WHERE return_id IS NULL;
```

**Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.**

```sql
SELECT 
	m.member_id,
	m.member_name,
	b.book_title,
	ist.issued_date,
	CURRENT_DATE - ist.issued_date AS days_overdue
FROM
	issued_status AS ist
JOIN
	members AS m
ON ist.issued_member_id = m.member_id
JOIN
	books AS b
ON ist.issued_book_isbn = b.isbn
LEFT JOIN
	return_status AS rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
AND CURRENT_DATE - ist.issued_date > 30
ORDER BY m.member_id;
```

**Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).**

```sql
CREATE OR REPLACE PROCEDURE alter_book_status (p_return_id VARCHAR(50), p_issued_id VARCHAR(50), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
	v_isbn VARCHAR(50);
	v_book_name VARCHAR(80);

BEGIN
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	VALUES
	(p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	SELECT
		issued_book_isbn,
		issued_book_name
		INTO
		v_isbn,
		v_book_name
	FROM
		issued_status
	WHERE issued_id = p_issued_id;
	
	UPDATE books
	SET status = 'yes'
	WHERE isbn = v_isbn;

	RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
END;
$$

-- Testing Function alter_book_status

issued_id = 'IS135'
ISBN = '978-0-307-58837-1'

CALL alter_book_status('RS140', 'IS135', 'Good');

SELECT * 
FROM books
WHERE isbn = '978-0-375-41398-8'

SELECT * FROM issued_status WHERE issued_book_isbn = '978-0-375-41398-8'

CALL alter_book_status('RS141', 'IS134', 'Poor');

SELECT * FROM issued_status;
```

**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
SELECT 
	b.branch_id,
	COUNT(ist.issued_book_isbn) AS total_books_issued,
	COUNT(rs.return_book_isbn) AS total_books_returned,
	SUM(bk.rental_price) AS total_revenue_generated
FROM
	branch b
JOIN
	employees e
ON b.branch_id = e.branch_id
JOIN
	issued_status ist
ON e.emp_id = ist.issued_emp_id
LEFT JOIN return_status rs
ON rs.issued_id = ist.issued_id
JOIN
	books bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id;
```

**Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members
containing members who have issued at least one book in the last 2 months.**

```sql
CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM active_members;
```

**Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.**

```sql
SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2;
```

**Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.**

```
CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(50), p_issued_member_id VARCHAR(50), p_issued_book_isbn VARCHAR(50), p_issued_emp_id VARCHAR(50))
LANGUAGE plpgsql
AS $$

DECLARE
-- declare all variables
	v_status VARCHAR(10);

BEGIN
-- all code logic
	-- check that book status is yes
	SELECT status 
	INTO
	v_status
	FROM books
	WHERE isbn = p_issued_book_isbn;
	
	IF v_status = 'yes' THEN
		INSERT INTO issued_status (issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES
		(p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

		UPDATE books
		SET status = 'no'
		WHERE isbn = p_issued_book_isbn;

		RAISE NOTICE 'Book record added successfully for book isbn: %', p_issued_book_isbn;

	ELSE
		RAISE NOTICE 'Unfortunately, the book you have requested is unavailable: %', p_issued_book_isbn;
	END IF;
END;
$$

-- Testing the function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'

```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, emplooyee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## Author - Catherine Omondi
