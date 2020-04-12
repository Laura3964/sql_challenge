DROP TABLE departments CASCADE;
DROP TABLE employees CASCADE;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS salaries;

CREATE TABLE departments (
dept_no VARCHAR (30) NOT NULL,
dept_name VARCHAR(30) NOT NULL,
CONSTRAINT pk_departments PRIMARY KEY (dept_no)
);

CREATE TABLE employees (
emp_no INT NOT NULL,
birth_date DATE,
first_name VARCHAR (30),
last_name VARCHAR (30),
gender CHAR(1) CHECK (gender IN ('M','F')),
hire_date DATE,
CONSTRAINT pk_employees PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR (30) NOT NULL,
emp_no INT NOT NULL,
from_date DATE,
to_date DATE,
CONSTRAINT fk_dept_manager_dept FOREIGN KEY (dept_no)
REFERENCES departments (dept_no),
CONSTRAINT fk_dept_manager_emp FOREIGN KEY (emp_no)
REFERENCES employees (emp_no)
);

CREATE TABLE dept_emp (
emp_no INT NOT NULL,
dept_no VARCHAR (30) NOT NULL,
from_date DATE,
to_date DATE,
CONSTRAINT fk_dept_emp_dept FOREIGN KEY (dept_no)
REFERENCES departments (dept_no),
CONSTRAINT fk_dept_emp_emp FOREIGN KEY (emp_no)
REFERENCES employees (emp_no)
);

CREATE TABLE salaries (
emp_no INT NOT NULL,
salary INT,
from_date DATE,
to_date DATE,
CONSTRAINT fk_salaries FOREIGN KEY (emp_no)
REFERENCES employees (emp_no)
);

CREATE TABLE titles (
emp_no INT NOT NULL,
title character varying (30) NOT NULL,
from_date DATE,
to_date DATE,
CONSTRAINT fk_titles FOREIGN KEY (emp_no)
REFERENCES employees (emp_no)
);

/*
1. List the following details of each employee: employee number, last name, first name, gender, and salary.
Perform an inner join on employees and salaries tables on emp_no
*/

DROP VIEW employee_name_gender_salary

CREATE VIEW employee_name_gender_salary AS
SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no
ORDER BY e.last_name;

SELECT *
FROM employee_name_gender_salary;

/*
2.	List employees who were hired in 1986.
*/

DROP VIEW employees_hired_1986

CREATE VIEW employees_hired_1986 AS
SELECT emp_no, last_name, first_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY hire_date;

SELECT *
FROM employees_hired_1986
ORDER BY hire_date;

/*
3. List the manager of each department with the following information:
department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
*/

DROP VIEW department_managers

CREATE VIEW department_managers AS
SELECT dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name, e.hire_date, dm.to_date as end_date
FROM  dept_manager AS dm
LEFT JOIN employees AS e
ON e.emp_no = dm.emp_no
LEFT JOIN departments AS d
ON d.dept_no = dm.dept_no;

SELECT *
FROM department_managers
ORDER BY dept_no;

/*
4.List the department of each employee with the following information:
employee number, last name, first name, and department name.
*/

DROP VIEW employee_and_dept

CREATE VIEW employee_and_dept AS
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
LEFT JOIN dept_emp AS de
ON de.emp_no = e.emp_no
LEFT JOIN departments AS d
ON d.dept_no = de.dept_no;

SELECT *
FROM employee_and_dept
ORDER BY emp_no

/*
5.	List all employees whose first name is "Hercules" and last names begin with "B."
*/


DROP VIEW Hercules_B

CREATE VIEW Hercules_B AS
SELECT first_name, last_name
FROM employees
WHERE first_name='Hercules' AND last_name LIKE 'B%';

SELECT *
FROM Hercules_B
ORDER BY last_name

/*
6.	List all employees in the Sales department, including their employee number, last name, first name, and department name.
*/

DROP VIEW sales_employees

CREATE VIEW sales_employees AS
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de
ON e.emp_no = de.emp_no
JOIN departments AS d
ON de.dept_no=d.dept_no
WHERE d.dept_name='Sales';

SELECT * 
FROM sales_employees
ORDER BY emp_no

/*
7.	List all employees in the Sales and Development departments, including their
employee number, last name, first name, and department name.
*/

DROP VIEW sales_and_development

CREATE VIEW sales_and_development AS
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
JOIN departments AS d
on (de.dept_no=d.dept_no)
where d.dept_name='Sales' or d.dept_name='Development';

SELECT *
FROM sales_and_development
ORDER BY emp_no

/*
8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
*/

DROP VIEW employee_freq_name

CREATE VIEW employee_freq_name AS
SELECT last_name, COUNT (last_name) AS "last name count" FROM employees
GROUP BY last_name
ORDER BY "last name count" DESC;

SELECT *
FROM employee_freq_name
ORDER BY last_name