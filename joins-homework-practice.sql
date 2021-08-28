-- 1. List all customers who live in Texas (use JOINs)
SELECT customer_id, first_name, last_name, a.address_id, district
FROM customer c
INNER JOIN address a
ON c.address_id = a.address_id
WHERE district = 'Texas';
-- Result: customre_id 6, 118, 305, 400, 561 which are
-- Jennifer Davis, Kim Cruz, Richard Mccray, Bryan Hardison, and Ian Still respectively.

-- 2. Get all payments above $6.99 with the Customer's Full Name
SELECT c.customer_id, first_name, last_name, amount, payment_id
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
WHERE amount > 6.99
ORDER BY amount;
-- Result: 1406

-- 3. Show all customers names who have made payments over $175 (use subqueries)
SELECT DISTINCT p.customer_id, first_name, last_name, SUM(amount)
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id, first_name, last_name
HAVING p.customer_id IN (
	SELECT DISTINCT payment.customer_id
	FROM payment
	GROUP BY payment.customer_id
	HAVING SUM(amount) > 175
)
ORDER BY SUM(amount) DESC;
-- Result: Eleanor Hunt $211.55, Karl Seal $208.58, Marion Snyder $194.61,
--		   Rhonda Kennedy $191.62, Clara Shaw $189.6, Tommy Collazo $183.63

-- 4. List all customers that live in Nepal (use the city table)
SELECT c.customer_id, first_name, last_name, country
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ON a.city_id = city.city_id
INNER JOIN country ON country.country_id = city.country_id
WHERE country = 'Nepal';
-- Result: customer_id 321 = Kevin Schuler

-- 5. Which staff member had the most transactions?
SELECT s.staff_id, first_name, last_name, COUNT(payment_id)
FROM staff s
INNER JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id, first_name, last_name
ORDER BY COUNT(payment_id) DESC;
-- Result: Jon Stephens with 7,304

-- 6. How many movies of each rating are there?
SELECT rating, COUNT(rating)
FROM film
GROUP BY rating
ORDER BY COUNT(rating) DESC;
-- Result: PG-13: 223, NC-17: 210, R: 195, PG: 194, G: 178

-- 7. Show all customers who have made a single payment above $6.99 (Use Subqueries)
SELECT c.customer_id, first_name, last_name
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount IN (
	SELECT amount
	FROM payment
	WHERE amount > 6.99
	GROUP BY amount
)
GROUP BY c.customer_id, first_name, last_name
HAVING count(p.amount) = 1
ORDER BY customer_id;
-- Result: 130 customers

-- 8. How many free rentals did our stores give away?
SELECT COUNT(rental_id)
FROM payment
WHERE amount = 0;
-- Result: 24