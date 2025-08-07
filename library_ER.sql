create database book_bazaar;
use book_bazaar;

create table user_(
user_id int PRIMARY KEY,
user_name varchar(30),
email varchar(30) UNIQUE NOT NULL,
user_pw varchar(10) UNIQUE NOT NULL,
address varchar(50) NOT NULL,
phone int
);

create table book(
book_id int PRIMARY KEY,
title varchar(30),
author varchar(30),
price int,
isbn_no int UNIQUE,
stock_quantity int,
category_ID int,
book_description varchar(20),
FOREIGN KEY(category_ID) REFERENCES category(category_id)
);

create table category(
category_id int PRIMARY KEY,
category_name varchar(20)
);

create table cart(
cart_id int PRIMARY KEY,
user_id int,
FOREIGN KEY(user_id) REFERENCES user_(user_id)
);

create table cart_item(
cart_itemID int PRIMARY KEY,
cart_id int,
book_id int,
quantity int,
FOREIGN KEY(cart_id) REFERENCES cart(cart_id),
FOREIGN KEY(book_id) REFERENCES book(book_id)
);

create table order_(
orderID int PRIMARY KEY,
user_id int,
orderDate datetime,
total_amt int,
status_ord varchar(10),
FOREIGN KEY(user_id) REFERENCES user_(user_id)
);

create table order_item(
order_itemID int PRIMARY KEY,
orderID int,
book_id int,
quantity int,
priceatpurchase int,
FOREIGN KEY(orderID) REFERENCES order_(orderID),
FOREIGN KEY(book_id) REFERENCES book(book_id)
);

create table admin_lib(
adminID int PRIMARY KEY,
admin_name varchar(30),
email varchar(30) UNIQUE NOT NULL,
pw varchar(10)
);