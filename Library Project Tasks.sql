-- Project Tasks

-- 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM books;
-- Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT issued_book_name
FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT
	issued_emp_id,
	COUNT(*) AS book_number
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_issued_cnt AS
SELECT 	
	b.book_title,
	COUNT(*) AS issued_times
FROM books b
JOIN issued_status i
ON b.isbn = i.issued_book_isbn
GROUP BY b.book_title;

SELECT * FROM book_issued_cnt;

-- Task 7. Retrieve All Books in a Specific Category:
SELECT * 
FROM books
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:
SELECT
	b.category,
	SUM(b.rental_price) AS total_rental_income,
	COUNT(*) AS times_rented
FROM books b
JOIN issued_status ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;

-- Task 9: List Members Who Registered in November 2021:
SELECT
	*
FROM members
WHERE TO_CHAR(reg_date, 'YYYY-MM') = '2021-11';

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
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

-- Task 11. Create a Table of Books with Rental Price Above 7 USD:
CREATE TABLE book_rental_price AS
SELECT
	book_title,
	rental_price
FROM books
WHERE rental_price > 7;

SELECT * FROM book_rental_price;

-- Task 12: Retrieve the List of Books not yet Returned
SELECT DISTINCT ist.issued_book_name 
FROM issued_status ist
LEFT JOIN return_status rs
ON ist.issued_id = rs.issued_id
WHERE return_id IS NULL;

/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.
*/
-- issued status of members-- books -- return status
-- filter books which have not been returned
-- are they overdue by more than 30 days?

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
AND CURRENT_DATE - ist.issued_date > 870
ORDER BY m.member_id;


/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/

SELECT * FROM books;
	