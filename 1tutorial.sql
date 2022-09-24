-- vyhledat vsechny informace o vseckych hercich
SELECT * FROM actor;


-- vyhledat jmena a prijmeni vsechnych hercu (projekce)
SELECT first_name, last_name FROM actor;


-- vyhledat jmena a prijmeni hercu se jmenem JOHNNY
SELECT first_name, last_name
FROM actor
WHERE first_name = 'JOHNNY';


-- vyhledat jmena a prijmeni hercu, kterym jmeno zacina na J
SELECT first_name, last_name
FROM actor
WHERE first_name LIKE 'J%'; -- zacina na J
--WHERE first_name LIKE '%J'; -- konci na J
--WHERE first_name LIKE '%J%'; -- obsahuje J


-- vyhledat jmena a prijmeni hercu, kterym jmeno zacina na J
-- a prijmeni je PITT
SELECT first_name, last_name
FROM actor
WHERE first_name LIKE 'J%' AND last_name = 'PITT';


-- vyhledat jmena a prijmeni hercu, kterym jmeno zacina na J
-- a prijmeni je PITT nebo DAVIS
SELECT first_name, last_name
FROM actor
WHERE first_name LIKE 'J%' AND (last_name = 'PITT' OR last_name = 'DAVIS');


-- vyhledat herce, kterym prijmeni je PITT, nebo DAVIS, nebo CHASE, nebo GUINESS
SELECT first_name, last_name
FROM actor
--WHERE last_name = 'PITT' OR last_name = 'DAVIS'
--OR last_name = 'CHASE' OR last_name = 'GUINESS';
WHERE last_name NOT IN ('PITT', 'DAVIS', 'CHASE', 'GUINESS');


-- vyhledat herce, kterym prijmeni neni PITT, nebo DAVIS, nebo CHASE, nebo GUINESS
SELECT first_name, last_name
FROM actor
--WHERE NOT (last_name = 'PITT' OR last_name = 'DAVIS'
--OR last_name = 'CHASE' OR last_name = 'GUINESS');
WHERE last_name != 'PITT' AND last_name != 'DAVIS'
AND last_name != 'CHASE' AND last_name != 'GUINESS';


-- vyhledat nazev filmu, ktery je delsi nez 60 min, ale kratsi nez 90 min.
-- vysledek setridte od nejdelsiho po nejkratsi film
SELECT title
FROM film
WHERE length > 60 AND length < 90
--WHERE length BETWEEN 61 AND 89
ORDER BY length DESC, title ASC;


-- vypiste vsechny vlastnosti filmu a setridte je od A do Z
-- odstrante duplicity
SELECT DISTINCT special_features, title
FROM film
ORDER BY special_features ASC;


-- vypiste nevracene pujcky
SELECT *
FROM rental
WHERE return_date IS NOT NULL;


-- vypiste pocet filmu v tabulce film
SELECT COUNT(*) FROM film;
SELECT COUNT(length) FROM film;
SELECT COUNT(DISTINCT special_features) FROM film;

-- vypiste minimalni, maximalni, prumernou a celkovou delku vsech filmu.
SELECT MIN(length) FROM film;
SELECT MAX(length) FROM film;
SELECT AVG(length) FROM film;
SELECT SUM(length) FROM film;


-- vypiste nazvy vseckych filmu a jejich jazyku
SELECT film.title, language.name
FROM film JOIN language ON film.language_id = language.language_id;

-- vypiste jmena, prijmeni, adresy a mesta vsech zakazniku
SELECT customer.first_name, customer.last_name, address.address, city.city
FROM customer
JOIN address on customer.address_id = address.address_id
JOIN city on address.city_id = city.city_id;


-- vypiste jmena filmu, ktere pujcovna vlastni aspon v jedne kopii
SELECT DISTINCT film.title, inventory.store_id
FROM film LEFT JOIN inventory ON film.film_id = inventory.film_id;


-- vypiste ID a castky vsech plateb a u kazde platby uvedte datum vypujcky
SELECT payment.payment_id, payment.amount, rental.rental_date
FROM payment LEFT JOIN  rental ON payment.rental_id = rental.rental_id;


-- u kazdeho filmu vypiste jazyk filmu, pokud jazyk zacina na "I",
-- v opacnem pripade vypiste NULL
SELECT film.title, language.name
FROM film LEFT JOIN language on film.language_id = language.language_id
AND language.name LIKE 'I%';


-- pro kazdy rok vypiste pocet filmu, ktere byli v danem roku vydany
SELECT release_year, COUNT(*)
FROM film
GROUP BY release_year

-- pro kazdy rating vypiste pocet filmu
SELECT rating, COUNT(*) as 'pocet_filmu'
FROM film
GROUP BY rating


-- vypiste ID zakazniku zetrizenych podle souctu jejich plateb
SELECT customer_id, sum(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;


-- vypiste ID skladu s vic nez 2300 kopiemi filmu
SELECT store_id, COUNT(*)
FROM inventory
GROUP BY store_id
HAVING count(*) > 2300;