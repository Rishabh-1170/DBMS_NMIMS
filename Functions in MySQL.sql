CREATE DATABASE BesantBank;
USE BesantBank;

CREATE TABLE account_details(
account_id int PRIMARY KEY,
name varchar(30) NOT NULL,
age tinyint CHECK(age>18),
accounttype varchar(20),
cur_balance int
);

CREATE TABLE transaction_details(
transaction_id int PRIMARY KEY AUTO_INCREMENT,
account_id int,
transaction_type varchar(10) CHECK(transaction_type='credit' or transaction_type='debit'),
transaction_amt int,
transaction_time datetime default(NOW()),
FOREIGN KEY(account_id) REFERENCES account_details(account_id)
);

INSERT INTO account_details
VALUE(1, 'Ram', 21, 'Saving', 2000),
(2, 'Sana', 23, 'Current', 500),
(3, 'John', 27, 'Saving', 1000),
(4, 'Peter', 25, 'Saving', 1500),
(5, 'Kiran', 27, 'Current', 5200),
(6, 'Priya', 21, 'Saving', 5500),
(7, 'Varun', 28, 'Current', 500),
(8, 'Sonu', 29, 'Saving', 2500),
(9, 'Kumar', 28, 'Saving', 2000),
(10, 'Jathin', 27, 'Current', 5000),
(11, 'Suma', 22, 'Saving', 1500);


INSERT INTO transaction_details (account_id, transaction_type, transaction_amt)
VALUES
(1,'credit',1000),
(1,'debit',500),
(7, 'credit', 1000);

-- FUNCTIONS --

-- sum function
SELECT SUM(cur_balance) AS Totalbalance
FROM account_details;

-- max function
SELECT MAX(cur_balance) as Maxbalance 
FROM account_details;

-- min function
SELECT MIN(cur_balance) as Minbalance 
FROM account_details;

-- distinct function
SELECT DISTINCT(accounttype) AS UniqueAccountType
FROM account_details;

-- count function
SELECT COUNT(*) AS Totalrecords
FROM account_details;

-- average function
SELECT AVG(cur_balance) AS Averagebalance
FROM account_details;

SELECT ROUND(AVG(cur_balance)) AS Averagebalance
FROM account_details;