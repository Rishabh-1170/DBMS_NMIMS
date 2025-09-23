CREATE DATABASE BesantBank;
USE BesantBank;

CREATE TABLE employees(
emp_id int PRIMARY KEY AUTO_INCREMENT,
empname varchar(30) NOT NULL,
department_id int,
FOREIGN KEY(department_id) REFERENCES department(department_id)
);

CREATE TABLE department(
department_id int PRIMARY KEY,
deptname varchar(30)
);

INSERT INTO department
VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Sales'),
(104, 'Marketing');

INSERT INTO employees (empname, department_id)
VALUES
('Ram', 101),
('Sham',102),
('Peter',101),
('John',103);

-- inner join --
SELECT e.emp_id, e.empname, d.deptname
FROM employees as e
INNER JOIN department as d
ON e.department_id=d.department_id;

SELECT e.*   -- selecting all columns of employee table, only * selects department tables also
FROM employees as e
INNER JOIN department as d
ON e.department_id=d.department_id;

-- left outer join --
SELECT e.emp_id, e.empname, d.department_id, d.deptname
FROM employees as e
LEFT JOIN department as d
ON e.department_id=d.department_id;

-- right outer join --
SELECT e.emp_id, e.empname, d.department_id, d.deptname
FROM employees as e
RIGHT JOIN department as d
ON e.department_id=d.department_id;

-- full outer join --
SELECT e.emp_id, e.empname, d.department_id, d.deptname
FROM employees as e
LEFT JOIN department as d
ON e.department_id=d.department_id
UNION     -- takes union of two queries (same as set theoretic union)
SELECT e.emp_id, e.empname, d.department_id, d.deptname
FROM employees as e
RIGHT JOIN department as d
ON e.department_id=d.department_id;

SELECT e.emp_id, e.empname, d.department_id, d.deptname
FROM employees as e
LEFT JOIN department as d
ON e.department_id=d.department_id
UNION ALL  -- stacks the output of the two queries with duplication
SELECT e.emp_id, e.empname, d.department_id, d.deptname
FROM employees as e
RIGHT JOIN department as d
ON e.department_id=d.department_id;

-- cross join --
SELECT e.emp_id, e.empname, d.department_id, d.deptname
FROM employees as e
CROSS JOIN department as d;

-- self join --
CREATE TABLE company(
emp_ID int PRIMARY KEY,
emp_name varchar(30) NOT NULL,
manager_id int NOT NULL
);

INSERT INTO company
VALUES
(1, 'John', 0),
(2, 'Alice', 1),
(3, 'Bob', 1),
(4, 'Mary', 2);

SELECT c.emp_name as employee_name, m.emp_name as manager_name
FROM company c
LEFT JOIN company m
ON c.manager_id=m.emp_id;

SELECT c.emp_name as employee_name, m.emp_name as manager_name
FROM company c
JOIN company m
ON c.manager_id=m.emp_id;
