-- vyhledavam studenty ktere maji ID v tabulce Studies
--SELECT name
--FROM Student
--WHERE stID IN(
--	SELECT stID
--	FROM Studies
--	WHERE year=2010
--)

-- Kapitola 4

-- 1
SELECT film_id, title
FROM film
WHERE film_id IN(
	SELECT film_id
	FROM film_actor
	WHERE actor_id = 1
)

-- 2
SELECT film_id
FROM film_actor
WHERE actor_id = 1;

-- 2.1
SELECT title
FROM film f
WHERE EXISTS (
	SELECT 1
	FROM film_actor fa
	WHERE f.film_id = fa.film_id AND actor_id = 1
	)

-- 3
SELECT film_id, title
FROM film
WHERE film_id IN(
	SELECT film_id
	FROM film_actor
	WHERE actor_id = 1
)
 AND film_id IN(
	SELECT film_id
	FROM film_actor
	WHERE actor_id = 10
)

-- 4
SELECT film_id, title
FROM film
WHERE film_id IN(
	SELECT film_id
	FROM film_actor
	WHERE actor_id = 1 OR actor_id = 10
)

-- 8
SELECT film_id, title
FROM film
WHERE film_id NOT IN (
	SELECT film_id
	FROM film_actor JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE actor.first_name = 'PENELOPE'
)

-- 8.1
SELECT film_id, title
FROM film
WHERE NOT EXISTS (
	SELECT 1
	FROM film_actor JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE film_actor.film_id = film.film_id AND actor.first_name = 'PENELOPE'
)

-- 33
SELECT inventory.film_id
FROM inventory JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY inventory.inventory_id, inventory.film_id
HAVING  COUNT(*) < 4

SELECT inventory.film_id
FROM inventory LEFT JOIN rental on inventory.inventory_id = rental.inventory_id
GROUP BY inventory.film_id
HAVING COUNT(rental.inventory_id) > 3

-- Kapitola 5

-- 1
SELECT film.title, (
	SELECT COUNT(*)
	FROM film_actor
	WHERE film.film_id = film_actor.film_id
	), (
	SELECT COUNT(*)
	FROM film_category
	WHERE film.film_id = film_category.film_id
	)
FROM film

-- 2
SELECT rental.customer_id,
	COUNT(CASE WHEN DATEDIFF(day, rental.return_date, rental.rental_date) < 5 THEN 1 END),
	COUNT(CASE WHEN DATEDIFF(day, rental.return_date, rental.rental_date) < 7 THEN 1 END)
FROM rental


SELECT *
FROM customer JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.customer_id