-- 1
SELECT *
FROM city JOIN country ON city.country_id = country.country_id;

-- 2
SELECT film.title, language.name
FROM film JOIN language ON film.language_id = language.language_id;

-- 3
SELECT rental_id
FROM rental JOIN customer ON rental.customer_id = customer.customer_id
WHERE customer.last_name = 'SIMPSON';

-- 4
SELECT address.address
FROM address JOIN customer ON address.address_id = customer.address_id
WHERE customer.last_name = 'SIMPSON';

-- 5
SELECT customer.first_name, customer.last_name, address.address, address.postal_code, city.city
FROM customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id;

-- 6
SELECT customer.first_name, customer.last_name, city.city
FROM customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id;

-- 7
SELECT rental.rental_id AS rental_id,
	staff.first_name AS staff_first_name,
	staff.last_name AS staff_last_name,
	customer.first_name AS customer_first_name,
	customer.last_name AS customer_last_name,
	film.title
FROM
	rental
	JOIN staff ON rental.staff_id = staff.staff_id
	JOIN customer ON rental.customer_id = customer.customer_id
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	JOIN film ON inventory.film_id = film.film_id;

-- 8
SELECT film.title, actor.first_name, actor.last_name
FROM
	film
	JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY film.title;

-- 9
SELECT actor.first_name, actor.last_name, film.title
FROM
	film
	JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY actor.last_name, actor.first_name;

-- 10
SELECT film.title
FROM film
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Horror';

-- 11
SELECT store.store_id,
	staff.first_name,
	staff.last_name,
	address_store.address AS address_store,
	address_staff.address AS address_staff,
	store_city.city AS city,
	store_country.country AS country
FROM store
	JOIN staff ON store.manager_staff_id = staff.staff_id
	JOIN address address_store ON store.address_id = address_store.address_id
	JOIN address address_staff ON staff.address_id = address_staff.address_id
	JOIN city store_city ON address_store.city_id = store_city.city_id
	JOIN country store_country ON store_city.country_id = store_country.country_id;