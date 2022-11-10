-- 1
SELECT rating, COUNT(*) AS pocet
FROM film
GROUP BY rating;

-- 2
SELECT customer_id, COUNT(last_name) AS pocet
FROM customer
GROUP BY customer_id;

-- 3
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount);

-- 4
SELECT first_name, last_name, COUNT(*) AS pocet
FROM actor
GROUP BY first_name, last_name
ORDER BY pocet DESC;

--5 
SELECT YEAR(payment_date) as rok, MONTH(payment_date) as mesic, SUM(amount) AS soucet
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY rok, mesic;