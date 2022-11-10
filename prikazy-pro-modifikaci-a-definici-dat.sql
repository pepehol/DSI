-- Moje pozn�mky.
--Zobraz� posledn� generovan� ID.
--SELECT @@IDENTITY;
--Zobraz� posledn� generovan� ID v dan� tabulce.
--SELECT IDENT_CURRENT('actor')

-- ON DELETE NO ACTION = defaultn�, neprovede nic p�is smaz�n�.
-- ON DELETE CASCADE = kaskadov� sma�e p�i smaz�n�.
-- ON DELETE SET NULL = nastav� dan� atributy na NULL.

-- DDL (Data Definition Language)
--CREATE TABLE tabulka - vytvo�� novou tabulku
--ALTER TABLE tabulka - uprav� struktury tabulky, kde
--	- ADD sloupec - p�id� sloupec
--	- ALTER COLUMN sloupec - uprav� sloupec,
--	- DROP COLUMN sloupec odstran� sloupec,
--	- ADD CONSTRAINT - p�id� integritn� omezen� (DEFAULT, CHECK, FOREIGN KEY, PRIMARY KEY)
--	- DROP CONSTRAINT - odstran� integritn� omezen�,
--DROP TABLE tabulka - odstran� tabulku

--DML (Data Manipulation Language)
--	INSERT
--	UPDATE
--	DELETE

-- 1 a ------------------------------------------------------------------------
SELECT * FROM actor;

INSERT INTO actor(first_name, last_name)
VALUES ('Arnold', 'Schwarzenegger');

-- 1 b
SELECT * FROM film WHERE title='Termin�tor';

INSERT INTO film(title, description, language_id, rental_duration, rental_rate, length)
VALUES ('Termin�tor', 'Z roku 2029 je do Los Angeles roku 1984 vysl�n zabij�ck� stroj podobn�
	�lov�ku...', 1, 3, 1.99, 107);

-- 1 c ------------------------------------------------------------------------
DECLARE @filmID int;
SET @filmID = (SELECT film_id FROM film WHERE title = 'Termin�tor');

DECLARE @actorID int;
SET @actorID = (SELECT actor_id FROM actor WHERE last_name = 'Schwarzenegger');

INSERT INTO film_actor(film_id, actor_id)
VALUES (@filmID, @actorID)

SELECT * FROM film_actor;
SELECT IDENT_CURRENT('film_actor')

-- 1 d ------------------------------------------------------------------------
DECLARE @filmID1 int;
SET @filmID1 = (
SELECT film_id
FROM film
WHERE title = 'Termin�tor'
);

DECLARE @categoryID int;
SET @categoryID = (SELECT category_id FROM category WHERE name = 'Action');

DECLARE @categoryID1 int;
SET @categoryID1 = (SELECT category_id FROM category WHERE name = 'Sci-Fi');

INSERT INTO film_category (film_id, category_id) VALUES (@filmID1, @categoryID);
INSERT INTO film_category (film_id, category_id) VALUES (@filmID1, @categoryID1);

SELECT * FROM film_category WHERE film_id = 1001;

-- 1 e ------------------------------------------------------------------------
INSERT INTO film_category (film_id, category_id) VALUES
(
	(SELECT film_id FROM film WHERE title = 'Termin�tor'),
	(SELECT category_id FROM category WHERE name = 'Comedy')
);

-- 1 f ------------------------------------------------------------------------
SELECT * FROM film WHERE title='Termin�tor';

UPDATE film
SET rental_rate = 2.99, last_update = CURRENT_TIMESTAMP
WHERE title = 'Termin�tor';

UPDATE film
SET rental_rate = 2.99, last_update = CURRENT_TIMESTAMP
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Termin�tor');


-- 2 a ------------------------------------------------------------------------

--SELECT * FROM country ORDER BY country;

DECLARE @idCZ int;
SET @idCZ = (SELECT country_id FROM country WHERE country = 'Czech Republic');
SELECT * FROM city WHERE country_id = @idCZ ORDER BY city;

-- Create my city.

INSERT INTO city (city, country_id)
VALUES ('Vset�n', @idCZ);

DECLARE @vsetinID int;
SET @vsetinID = (SELECT city_id FROM city WHERE city = 'Vset�n');

--SELECT * FROM address WHERE city_id = @vsetinID;

INSERT INTO address (address, district, city_id, phone)
VALUES ('Na konci 1', 'Vset�n', @vsetinID, '+420 358 478 694');

DECLARE @adressID int;
SET @adressID = (SELECT address_id FROM address WHERE address = 'Na konci 1');

INSERT INTO staff (first_name, last_name, address_id, store_id, username)
VALUES ('Josef', 'Holi�', @adressID, 2, 'hol0125');

--SELECT * FROM staff WHERE username = 'hol0125';

-- 2 b ------------------------------------------------------------------------

DECLARE @idCZ1 int;
SET @idCZ1 = (SELECT country_id FROM country WHERE country = 'Czech Republic');

INSERT INTO city (city, country_id)
VALUES ('Ostrava', @idCZ1);

DECLARE @idOstrava int;
SELECT @idOstrava = city_id FROM city WHERE city = 'Ostrava'

--SELECT * FROM address WHERE city_id = @idOstrava;

INSERT INTO address (address, district, city_id, phone)
VALUES ('17. listopadu 2172/15', 'Okres Ostrava', @idOstrava, '+420 597 326 001');

-- 2 c ------------------------------------------------------------------------

SELECT * FROM store;
SELECT * FROM staff;

INSERT INTO store (manager_staff_id, address_id) VALUES
(
	(SELECT staff_id FROM staff WHERE username = 'hol0125'),
	(SELECT address_id FROM address WHERE address = '17. listopadu 2172/15')
);

-- 2 d ------------------------------------------------------------------------

SELECT * FROM store;
SELECT * FROM inventory;

-- Soupis kopi� film�.
SELECT i1.inventory_id
FROM inventory i1
WHERE i1.inventory_id >= ALL (
	SELECT i2.inventory_id
	FROM inventory i2
	WHERE i1.film_id = i2.film_id
);

DECLARE @idStoreOstrava int;
SELECT @idStoreOstrava = store_id FROM store WHERE address_id = (
	SELECT address_id FROM address WHERE address = '17. listopadu 2172/15'
);

PRINT @idStoreOstrava;

--UPDATE inventory
--SET store_id = @idStoreOstrava
--WHERE inventory_id IN (
--	SELECT i1.inventory_id
--	FROM inventory i1
--	WHERE i1.inventory_id >= ALL (
--		SELECT i2.inventory_id
--		FROM inventory i2
--		WHERE i1.film_id = i2.film_id
--	)
--)

-- Zjednodu�en� z�pis.
--UPDATE inventory
--SET store_id = @idStoreOstrava
--WHERE inventory_id >= ALL (
--	SELECT i2.inventory_id
--	FROM inventory i2
--	WHERE inventory.film_id = i2.film_id
--);

-- Zjednodu�en� z�pis. Pomoc� FROM, pouze MS SQL server.
UPDATE i1
SET store_id = @idStoreOstrava
FROM inventory i1
WHERE i1.inventory_id >= ALL (
	SELECT i2.inventory_id
	FROM inventory i2
	WHERE i1.film_id = i2.film_id
);

-- 3 --------------------------------------------------------------------------

SELECT film_actor.film_id, title
FROM film_actor
JOIN actor ON film_actor.actor_id = actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE first_name = 'ZERO' AND last_name = 'CAGE';


UPDATE film
SET rental_rate = rental_rate * 1.1
WHERE film_id IN (
	SELECT film_id
	FROM film_actor
	JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE first_name = 'ZERO' AND last_name = 'CAGE'
);

-- 4 --------------------------------------------------------------------------

SELECT * FROM language;

UPDATE film
SET original_language_id = NULL
WHERE original_language_id =
	(SELECT language_id FROM language WHERE name = 'Mandarin');

-- 5 --------------------------------------------------------------------------

INSERT INTO inventory (film_id, store_id)
SELECT film_id, 2
FROM actor
	JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE first_name = 'GROUCHO' AND last_name = 'SINATRA';

-- 6 --------------------------------------------------------------------------

SELECT * FROM language;

INSERT INTO language (name)
VALUES ('Mandarin');

DELETE FROM language
WHERE name = 'Mandarin';

-- 7 --------------------------------------------------------------------------

DELETE FROM film WHERE title = 'Termin�tor';

DELETE 
FROM film_actor
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Termin�tor');

DELETE
FROM film_category
WHERE film_id = (SELECT film_id FROM film WHERE title = 'Termin�tor');

-- 8 --------------------------------------------------------------------------

SELECT * FROM customer;

-- Odstran�n� plateb a to bu� p��mo, nebo na n� odkazuj�.
DELETE
FROM payment
WHERE
	rental_id IN (
		SELECT rental.rental_id
		FROM customer JOIN rental ON customer.customer_id = rental.customer_id
		WHERE customer.active = 0
	)
	OR customer_id IN
	(
		SELECT customer_id
		FROM customer
		WHERE active = 0
);

-- Odstran�n� v�puj�ek.
DELETE
FROM rental
WHERE customer_id IN (SELECT customer_id FROM customer WHERE active = 0);

-- Odstran�n� neaktivn�ch z�kazn�k�.
DELETE
FROM customer
WHERE active = 0;

-- 9 --------------------------------------------------------------------------

SELECT * FROM inventory;
SELECT * FROM film;

ALTER TABLE film
ADD inventory_count INT;

UPDATE film
SET inventory_count = (
	SELECT COUNT(*)
	FROM inventory
	WHERE inventory.film_id = film.film_id
);

-- 10 -------------------------------------------------------------------------

ALTER TABLE category
ALTER COLUMN name VARCHAR(50);

-- 11 -------------------------------------------------------------------------

SELECT * FROM customer;
SELECT * FROM address;

-- Prvn� nastav�me atribut jako nepovin� a pot� jej definujeme.
ALTER TABLE customer
ADD phone VARCHAR(20);

UPDATE customer
SET phone = (
	SELECT phone
	FROM address
	WHERE address.address_id = customer.address_id
);

ALTER TABLE customer
ALTER COLUMN phone VARCHAR(50) NOT NULL;

-- 12 -------------------------------------------------------------------------

SELECT * FROM rental;

-- Druh� mo�nost nastaven� v�choz� hodnoty.
ALTER TABLE rental
ADD create_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE rental
ADD create_date DATETIME NOT NULL 
	CONSTRAINT DF_rental_create_date DEFAULT CURRENT_TIMESTAMP;

-- 13 -------------------------------------------------------------------------

SELECT * FROM rental;

ALTER TABLE rental
DROP COLUMN create_date;

-- Nejprve smazat integritn� omezen�.
ALTER TABLE rental
DROP CONSTRAINT DF_rental_create_date;

-- 14 -------------------------------------------------------------------------

SELECT * FROM film;

ALTER TABLE film
ADD creator_staff_id TINYINT NULL;

ALTER TABLE film
ADD FOREIGN KEY (creator_staff_id) REFERENCES staff (staff_id);

-- Ciz� kl�� m� integritn� omezen�, proto je lep�� si jej pojmenovat.
ALTER TABLE film
ADD CONSTRAINT FK_film_staff FOREIGN KEY (creator_staff_id) REFERENCES staff (staff_id);

-- Pojmenov�n� m��eme p��mo p�i vytvo�en�.

ALTER TABLE film
ADD creator_staff_id TINYINT NULL CONSTRAINT FK_film_staff FOREIGN KEY REFERENCES staff (staff_id);

-- 15 -------------------------------------------------------------------------
-- Automatick� kontrola atributu.

SELECT * FROM staff;

ALTER TABLE staff
ADD CONSTRAINT check_email CHECK (email LIKE '%@%.%');

-- 16 -------------------------------------------------------------------------
-- Zru�en� automatick� kontroly.

ALTER TABLE staff
DROP CONSTRAINT check_email;

-- 17 -------------------------------------------------------------------------
-- Automatick� kontrola datumu, jedno mus� b�t v�dy v�t��.

ALTER TABLE rental
ADD CONSTRAINT check_dates CHECK (return_date > rental_date);

-- 18 -------------------------------------------------------------------------
-- Vytvo�en� tabulky s atributy, prim�rn�m a ciz�m kl��em.
-- Prim�rn� kl�� se aut. generuje.

CREATE TABLE reservation
(
	reservation_id TINYINT IDENTITY PRIMARY KEY NOT NULL,
	reservation_date DATE NOT NULL,
	end_date DATE NOT NULL,
	customer_id INT CONSTRAINT fk_reservation_customer FOREIGN KEY
		REFERENCES customer (customer_id),
	film_id INT CONSTRAINT fk_reservation_film FOREIGN KEY
		REFERENCES film (film_id),
	staff_id TINYINT CONSTRAINT fk_reservation_staff FOREIGN KEY
		REFERENCES staff (staff_id)
);

-- 19 -------------------------------------------------------------------------
-- Vlo�en� z�znamu do n�mi vytvo�en� tabulky.
-- Maz�n� / p�id�v�n� z�znam� a kontrola jejich prim�rn�ch kl���.

SELECT * FROM customer;
SELECT * FROM film;
SELECT * FROM staff;
SELECT * FROM reservation;

INSERT INTO reservation (reservation_date, end_date, customer_id, film_id, staff_id)
VALUES ('2022-10-02', '2022-10-05', 25, 10, 3);

INSERT INTO reservation (reservation_date, end_date, customer_id, film_id, staff_id)
VALUES ('2022-10-02', '2022-10-15', 56, 78, 2);

DELETE FROM reservation
WHERE reservation_id = 2;

INSERT INTO reservation (reservation_date, end_date, customer_id, film_id, staff_id)
VALUES ('2022-10-20', '2022-10-11', 5, 64, 2);

-- 20 a -----------------------------------------------------------------------
-- Vytvo�en� tabulky, vytvo�en� slo�en�ho kl��e.
-- Automatick� maz�n� pokud je smaz�n z�znam z tabulek slo�en�ho kl��e.

CREATE TABLE review
(
	film_id INT NOT NULL
		CONSTRAINT fk_review_film
		FOREIGN KEY REFERENCES film (film_id) ON DELETE CASCADE,
	customer_id INT NOT NULL
		CONSTRAINT fk_review_customer
		FOREIGN KEY REFERENCES customer (customer_id) ON DELETE CASCADE,
	stars TINYINT NOT NULL
		CONSTRAINT ch_review_stars
		CHECK (stars BETWEEN 1 AND 5),
	actor_id INT NULL
		CONSTRAINT fk_review_actor
		FOREIGN KEY REFERENCES actor (actor_id) ON DELETE SET NULL,
	PRIMARY KEY (film_id, customer_id)
);

-- Ekvivalentn�j�� z�pis.

CREATE TABLE review
(
	film_id INT NOT NULL,
	customer_id INT NOT NULL,
	stars TINYINT NOT NULL,
	actor_id INT NULL,
	PRIMARY KEY (film_id, customer_id),
	CONSTRAINT fk_review_film
		FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE CASCADE,
	CONSTRAINT fk_review_customer
		FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE CASCADE,
	CONSTRAINT fk_review_actor 
		FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE SET NULL,
	CONSTRAINT ch_review_stars CHECK (stars BETWEEN 1 AND 5)
);

-- 20 b -----------------------------------------------------------------------
-- Vlo�it do vytvo�en� tabulky z�znamy.

SELECT * FROM film WHERE title = 'ARSENIC INDEPENDENCE';
SELECT * FROM film_actor WHERE film_id = 41; 
SELECT * FROM actor WHERE first_name = 'EMILY' and last_name = 'DEE';


SELECT *
FROM actor JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id = 41;

SELECT title
FROM film 
	JOIN film_actor ON film.film_id = film_actor.film_id
	JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name = 'EMILY' AND actor.last_name = 'DEE';

INSERT INTO review (film_id, customer_id, stars, actor_id)
VALUES (40, 318, 4, NULL);

INSERT INTO review (film_id, customer_id, stars, actor_id)
VALUES (41, 59, 5, 148);

SELECT * FROM review;

-- 20 c -----------------------------------------------------------------------
-- Odstran�n� z�znam� z tabelek pomoc� kask�dov�ho maz�n�.
-- Odstra�ujeme z tabulky v��e.

DELETE FROM customer
WHERE customer_id = 318;

DELETE FROM actor
WHERE actor_id = 148;

-- 21 -------------------------------------------------------------------------
-- Zalohov�v�n� tabulek.

CREATE TABLE film_backup
(
	film_id INT,
	title VARCHAR(255),
	description TEXT,
	release_year VARCHAR(4),
	language_id TINYINT,
	original_language_id TINYINT,
	rental_duration TINYINT,
	rental_rate DECIMAL(4, 2),
	length SMALLINT,
	replacement_cost DECIMAL(5, 2),
	rating VARCHAR(10),
	special_features VARCHAR(255),
	last_update DATETIME
);

INSERT INTO film_backup (
film_id, title, description, release_year, language_id,
original_language_id, rental_duration, rental_rate,
length, replacement_cost, rating, special_features, last_update)
SELECT
film_id, title, description, release_year, language_id,
original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, 
special_features, last_update
FROM film;

-- Elegantn�j�� �e�en�, plat� jenom pro MS SQL.
SELECT * INTO film_backup
FROM film;

DROP TABLE film_backup;
DROP TABLE review;

-- 23 -------------------------------------------------------------------------
-- Vytvo�en� nov� tabulky, kter� bude jako "ciz� kl��".

SELECT * FROM film;

--Vytvo�en� tabulky.
CREATE TABLE rating
(
	rating_id TINYINT NOT NULL IDENTITY PRIMARY KEY,
	name VARCHAR(10) NOT NULL,
	description TEXT NULL
);

SELECT * FROM rating;

-- Nahr�n� dat z jin� tabulky.
INSERT INTO rating (name)
SELECT DISTINCT rating
FROM film;

-- Vytvo�en� ciz�ho kl��e.
ALTER TABLE film
ADD rating_id TINYINT NULL CONSTRAINT fk_film_rating FOREIGN KEY
	REFERENCES rating (rating_id);

-- Nastaven� ciz�ho kl��e v tabulce film.
UPDATE film
SET rating_id = (
	SELECT rating_id
	FROM rating
	WHERE rating.name = film.rating
);

-- Nastaven� ciz�ho kl��e v tabulce film jako povinn�.
ALTER TABLE film
ALTER COLUMN rating_id TINYINT NOT NULL;

-- Odstran�n� atributu film.rating.
ALTER TABLE film
DROP COLUMN rating;

ALTER TABLE film
DROP CONSTRAINT DF__film__rating__44FF419A;

ALTER TABLE film
DROP CONSTRAINT CHECK_special_rating;

-- 24 -------------------------------------------------------------------------
-- Odstran�n� v�ech tabulek.
-- Odstran�n� v po�ad� aby se nesetkaly ciz� kl��e.

DROP TABLE film_actor;
DROP TABLE film_category;

DROP TABLE actor;
DROP TABLE category;

-- Pokud nelze, m��eme odebrat ciz� kl��e.
ALTER TABLE staff
DROP CONSTRAINT fk_staff_store;

ALTER TABLE store
DROP CONSTRAINT fk_store_staff;

-- Nebo pomoc� syst�mov�ch katalogu.
-- Zobrazen� tabulek a ciz�ch kl���.
SELECT ctu.TABLE_NAME, rc.CONSTRAINT_NAME
FROM
	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
	JOIN INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE ctu ON
		rc.CONSTRAINT_NAME = ctu.CONSTRAINT_NAME

-- Vyps�n� samotn�ch p��kazu pro DROP
SELECT 'ALTER TABLE ' + ctu.TABLE_NAME + 'DROP CONSTRAINT ' + rc.CONSTRAINT_NAME
FROM
	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
	JOIN INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE ctu ON
		rc.CONSTRAINT_NAME = ctu.CONSTRAINT_NAME

-- Vyps�n� p��kaz� pro DROP tabulek, kter� nemaj� ciz� kl��e.
SELECT 'DROP TABLE ' + TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'