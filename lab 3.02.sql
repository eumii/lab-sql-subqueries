-- Active: 1670003109987@@127.0.0.1@3306@sakila


-- How many copies of the film Hunchback Impossible exist in the inventory system?
-- List all films whose length is longer than the average of all the films.
-- Use subqueries to display all actors who appear in the film Alone Trip.
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
-- Customers who spent more than the average payments.


USE sakila;

-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT count(inventory.store_id), film.title
FROM film 
JOIN inventory 
USING(film_id)
WHERE film.title = 'Hunchback Impossible';

-- 2 List all films whose length is longer than the average of all the films.
SELECT title 
FROM film
WHERE length > (
  SELECT avg(length)
  FROM film
);


-- 3 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT film_id FROM sakila.film
where title = 'alone trip'; 

-- SELECT sakila.actor FROM (SELECT film_id
-- FROM sakila.film_actor
-- where title = 'Alone Trip') sub;

SELECT first_name, last_name FROM actor 
WHERE actor_id IN (
    SELECT film_id
    FROM film 
    WHERE title = 'Alone Trip')
;

SELECT actor.first_name, actor.last_name FROM actor
 WHERE actor_id IN (
	SELECT actor_id FROM film_actor
    WHERE film_id in (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'));

-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT title FROM film
WHERE film_id IN
    (SELECT film_id FROM film_category
    WHERE category_id IN 
        (SELECT category_id FROM category
        where name = 'family'));


-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins.
--  Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
--  that will help you get the relevant information.


SELECT first_name, last_name, email FROM customer 
WHERE address_id IN (
    SELECT address_id FROM address 
    WHERE city_id IN (
        SELECT city_id from city 
        WHERE country_id IN 
            (SELECT country_id FROM country 
            WHERE country IN ('Canada'))));

-- 6 Which are films starred by the most prolific actor?
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- SELECT title FROM film
-- WHERE film_id IN
--     (SELECT film_id FROM film_actor
--     where actor_id IN  
--         (SELECT actor_id FROM film_actor
--         GROUP BY actor_id
--         ORDER BY count(actor_id) DESC)
--         GROUP BY film_id
--         ORDER BY film_id DESC)
-- GROUP BY film_id
-- ;




SELECT film_id FROM film_actor WHERE actor_id IN (
		SELECT actor_id
		FROM film_actor
		GROUP BY actor_id
		ORDER BY COUNT(actor_id) DESC
		LIMIT 1)
        ;

-- 7 Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT distinct title FROM film
WHERE film_id IN 
    (SELECT film_id FROM inventory
    WHERE inventory_id IN
        (SELECT inventory_id FROM rental
        WHERE customer_id =
            (SELECT customer_id FROM payment
            GROUP BY customer_id
            ORDER BY sum(amount) DESC
            LIMIT 1))); 

-- 8 Customers who spent more than the average payments.

SELECT customer_id, sum(amount)
FROM payment
GROUP BY customer_id
having moy > (
    SELECT avg(amount) AS moy FROM 
        (SELECT sum(amount) AS total
        FROM payment
        GROUP BY customer_id
        order by total DESC
        LIMIT 1))
;
SELECT SUM(amount) AS Total, customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > SUM(amount)/COUNT(customer_id)
ORDER BY SUM(amount) DESC;

SELECT avg(amount) FROM payment;






