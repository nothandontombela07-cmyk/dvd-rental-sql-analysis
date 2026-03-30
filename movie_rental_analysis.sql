-- ===================================
-- CREATE TABLES
-- ===================================

CREATE TABLE film(
film_id INTEGER,
title TEXT,
description TEXT,
release_year INTEGER,
language_id INTEGER,
original_language_id INTEGER,
rental_duration INTEGER,
rental_rate NUMERIC,
length INTEGER,
replacement_cost NUMERIC,
rating TEXT,
last_update TEXT,
special_features TEXT,
fulltext TEXT);

CREATE TABLE rental(
rental_id INTEGER,
rental_date TIMESTAMP,
inventory_id INTEGER,
customer_id INTEGER,
return_date TIMESTAMP,
staff_id INTEGER,
last_update TIMESTAMP
);

CREATE TABLE inventory(
inventory_id INTEGER,
film_id INTEGER,
store_id INTEGER,
last_update TIMESTAMP
);

CREATE TABLE customer(
customer_id INTEGER,
store_id INTEGER,
first_name TEXT,
last_name TEXT,
email VARCHAR(255),
address_id INTEGER,
activebool BOOLEAN,
create_date DATE,
last_update TIMESTAMP,
active BOOLEAN
);

CREATE TABLE payment(
payment_id INTEGER,
customer_id INTEGER,
staff_id INTEGER,
rental_id INTEGER,
amount NUMERIC,
payment_date TIMESTAMP
);

-- ==========================================
-- JOIN TABLES
-- ==========================================

SELECT 
f.title,
f.rental_rate,
r.rental_date,
c.customer_id,
p.amount
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN customer AS c ON r.customer_id = c.customer_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id;

-- ====================================================
-- ANALYSIS QUERIES
-- ====================================================

-- Q1: Total revenue
SELECT SUM(amount) AS total_revenue
FROM payment;

-- Q2: Top 10 customers

SELECT CONCAT(c.first_name,' ',c.last_name) AS customer_fullname, SUM(amount) AS total_spent
FROM payment AS p
INNER JOIN customer AS c ON p.customer_id = c.customer_id
GROUP BY CONCAT(c.first_name,' ',c.last_name)
ORDER BY total_spent DESC
LIMIT 10;

-- Q3: Most rented movies

SELECT f.title, COUNT(*) AS times_rented
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY times_rented DESC
LIMIT 10;

-- Q4: Revenue per movie

SELECT f.title, SUM(p.amount) AS revenue
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
INNER JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY revenue DESC
LIMIT 10;


-- Q5:Rentals over time

SELECT DATE_TRUNC('month', rental_date) AS rental_month,
TO_CHAR(DATE_TRUNC('month', rental_date), 'Mon') AS month_name, 
COUNT(*) AS total_rentals
FROM rental
GROUP BY rental_month
ORDER BY rental_month;
