USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name AS 'First Name', last_name AS 'Last Name'
  FROM actor;
  
  
-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id AS 'Actor ID', first_name AS 'First Name', last_name AS 'Last Name'
  FROM actor
  WHERE first_name = "Joe";
  
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name AS 'First Name', last_name AS 'Last Name'
  FROM actor
  WHERE last_name LIKE '%GEN%';
  
-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT*FROM actor;

SELECT first_name AS 'First Name', last_name AS 'Last Name'
  FROM actor
  WHERE last_name LIKE '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following 
-- countries: Afghanistan, Bangladesh, and China:
SELECT*FROM country;

SELECT country_id AS 'Country ID', country AS 'Country'
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description,
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
SELECT*FROM actor;

ALTER TABLE actor
ADD COLUMN description BLOB 
AFTER last_name;

SELECT*FROM actor;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

SELECT*FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name As 'Actor Last Name', COUNT(last_name) AS 'No. Who Share with Same Last Name'
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT last_name As 'Actor Last Name', COUNT(last_name) AS 'Last Name Shared with Atleast Two Others'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.

SELECT*FROM actor
WHERE first_name = 'GROUCHO';

UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = 172;

SELECT*FROM actor
WHERE first_name = 'HARPO';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
SELECT*FROM actor
WHERE first_name = 'HARPO';

UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id= '172';

SELECT*FROM actor
WHERE first_name = 'GROUCHO';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html

DESCRIBE address;


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT*FROM address;

SELECT*FROM staff;

SELECT s.first_name AS 'First Name', s.last_name AS 'Last Name',  a.address AS 'Address'
FROM staff s
JOIN address a
ON (s.address_id = a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT*FROM staff;

SELECT*FROM payment;

SELECT p.staff_id AS 'Staff ID', s.first_name AS 'First Name', s.last_name AS 'Last Name', SUM(p.amount) AS 'Total Payments'
FROM staff s
INNER JOIN payment p
ON (s.staff_id = p.staff_id)
GROUP BY p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT*FROM film;

SELECT*FROM film_actor;

SELECT fa.film_id AS 'Film ID', f.title As 'Film Title', COUNT(fa.actor_id) AS 'Number of Actors in Film'
FROM film_actor fa, film f
WHERE fa.film_id = f.film_id
GROUP BY fa.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT*FROM film;

SELECT*FROM inventory;

SELECT i.film_id AS 'Film ID', f.title AS 'Book Title', COUNT(i.inventory_id) AS 'Number of Copies in Inventory'
FROM inventory i, film f
WHERE i.film_id IN 
	(SELECT f.film_id FROM film f 
	WHERE f.title LIKE 'Hunchback Impossible')
AND i.film_id = f.film_id;

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT*FROM payment;

SELECT*FROM customer;

SELECT c.last_name AS 'Last Name', c.first_name AS 'First Name', SUM(p.amount) AS 'Total Amount Paid by Customer'
FROM payment p, customer c
WHERE p.customer_id = c.customer_id
GROUP BY c.last_name, c.first_name
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT*FROM film;

SELECT*FROM language;

SELECT title AS 'Films beginning with either K or Q'
FROM film f
WHERE f.language_id IN
	(SELECT l.language_id
	FROM language l
	WHERE l.name = 'English')
	AND f.title LIKE 'K%' OR f.title LIKE 'Q%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT*FROM film_actor;

SELECT*FROM actor;

SELECT*FROM film;

SELECT a.first_name AS 'First Name', a.last_name AS 'Last Name'
FROM actor a
WHERE a.actor_id IN
	(SELECT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id IN
		(SELECT f.film_id 
        FROM film f
        WHERE f.title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT*FROM customer;

SELECT*FROM address;

SELECT*FROM city;

SELECT*FROM country;

SELECT c.first_name  AS 'First Name', c.last_name  AS 'Last Name', 
	c.email  AS 'Email Address', co.country_id AS 'Country ID', ci.city_id  AS 'City ID', co.country AS 'Country Name'
FROM customer c, address a, country co, city ci
WHERE c.address_id = a.address_id 
	AND a.city_id = ci.city_id 
    AND ci.country_id = co.country_id
    AND country = 'Canada';
    
-- 7d. Sales have been lagging among young families, and you wish to target all 
-- family movies for a promotion. Identify all movies categorized as family films.

SELECT*FROM film_list;

SELECT title As 'Family Films'
FROM film_list
WHERE category = 'family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT*FROM rental;

SELECT*FROM inventory;

SELECT*FROM film;

SELECT f.title AS 'Most Frequently Rented Films' , COUNT(r.rental_id) AS ' Ranked from Highest to Lowest'
FROM inventory i, film f, rental r
WHERE f.film_id = i.film_id 
	AND i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(f.title) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT*FROM customer;

SELECT*FROM payment;

SELECT c.store_id AS 'Store ID', SUM(p.amount) AS 'Total Business ($)'
FROM customer c, payment p
WHERE c.customer_id = p.customer_id
GROUP BY c.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT*FROM store;

SELECT*FROM address;

SELECT*FROM city;

SELECT*FROM country;

SELECT s.store_id AS 'Store ID', ci.city AS 'City Name', co.country AS 'Country Name'
FROM store s, address a, city ci, country co
WHERE s.address_id = a.address_id
	AND a.city_id = ci.city_id
    AND ci.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: 
-- category, film_category, inventory, payment, and rental.)
SELECT*FROM category;

SELECT*FROM film_category;

SELECT*FROM inventory;

SELECT*FROM rental;

SELECT*FROM payment;

SELECT c.name AS 'Top 5 Film Genres', SUM(p.amount) AS 'Gross Revenue ($)'
FROM category c, film_category fc, inventory i, rental r, payment p
WHERE c.category_id = fc.category_id
	AND fc.film_id = i.film_id
    AND i.inventory_id = r.inventory_id
    AND r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;
    
-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW Top_5_Film_Genres_with_Gross_Revenues AS
	(SELECT c.name AS 'Top 5 Film Genres', SUM(p.amount) AS 'Gross Revenue ($)'
	FROM category c, film_category fc, inventory i, rental r, payment p
	WHERE c.category_id = fc.category_id
		AND fc.film_id = i.film_id
		AND i.inventory_id = r.inventory_id
		AND r.rental_id = p.rental_id
	GROUP BY c.name
	ORDER BY SUM(p.amount) DESC
	LIMIT 5);

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_5_Film_Genres_with_Gross_Revenues;

-- 8c. You find that you no longer need the view top_five_genres. 
-- Write a query to delete it.
DROP VIEW Top_5_Film_Genres_with_Gross_Revenues;