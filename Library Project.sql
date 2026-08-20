-- Library Management System Project

-- Create branch table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
	branch_id VARCHAR(10) PRIMARY KEY,
	manager_id VARCHAR(10),
	branch_address VARCHAR(50),
	contact_no VARCHAR(50)
);

-- Create employees table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
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

-- Foreign Key
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

