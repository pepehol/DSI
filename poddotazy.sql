-- 14 -------------------------------------------------------------------------

SELECT rating, title
FROM film f1
WHERE length = (
	SELECT MAX(length)
	FROM film f2
	WHERE f1.rating = f2.rating
)
ORDER BY rating;

SELECT rating, title
FROM film f1
WHERE length >= ALL (
	SELECT length
	FROM film f2
	WHERE f1.rating = f2.rating
)
ORDER BY rating;
