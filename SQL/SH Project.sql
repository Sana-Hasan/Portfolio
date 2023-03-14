




-- 1) List of all staff members and relevant info (first and last name, email, and store IDs) :
SELECT 
	first_name,
    last_name,
    email,
    store_id
FROM
	staff;
    
-- 2) Require seperate counts of inventory items at each of 2 stores:
SELECT
	store_id,
	COUNT(inventory_id)
FROM
inventory
GROUP by 
	store_id;

-- 3) Require count of active customers for each store :
SELECT
	store_id,
	COUNT(customer_id) AS active_customers
FROM
customer
WHERE 
	active = 1
GROUP by 
	store_id;

-- 4) Require a count of all customer emails in the database :
SELECT 
	count(email) AS Customer_emails
FROM
customer;

-- 5) Number of unique film titles for each store and count of unique film categories 

SELECT 
	count(DISTINCT category_id)
FROM
film_category;

SELECT 
	store_id,
	count(DISTINCT film_id) AS Number_Unique_Movies
FROM
inventory
GROUP BY
	store_id;
	
    
-- 6) Replacement cost - a) lowest cost b) most expensive c) average cost 

SELECT 
	MIN(replacement_cost),
    MAX(replacement_cost),
    AVG(replacement_cost)
FROM
film;

-- 7) Information required on payment amounts processed - b) Average payment processed c) Maximum payment processed

SELECT 
    MAX(amount) AS Highest_payment,
    AVG(amount) AS Avg_payment
FROM
payment;

-- 8) List of customer ID value, with a) count of rentals they have made all-time 

SELECT 
customer_id 
from
rental;

SELECT 
   customer_id,
   COUNT(rental_id) AS total_rentals
FROM
	rental
Group BY
	customer_id 
ORDER BY
	total_rentals DESC;
    
-- join
SELECT 
	inventory.inventory_id,
    inventory.store_id,
    film.film_id,
    film.description
FROM inventory
	INNER JOIN film
		ON inventory.film_id = film.film_id; 


-- 1) Managers' details for each store including street address, district, city and country
        
SELECT 
    staff.first_name,
    staff.last_name,
    address.address,
    address.district,
    city.city,
    country.country
FROM store
	LEFT JOIN staff
		ON store.manager_staff_id = staff.staff_id
	LEFT JOIN address
		ON store.address_id = address.address_id
    LEFT JOIN city
		ON address.city_id = city.city_id
	LEFT JOIN country
		ON city.country_id = country.country_id;
        
-- 2) Inventory for each of the stores
SELECT
	inventory.inventory_id,
    inventory.store_id,
    film.title,
    film.rating,
    film.rental_rate,
    film.replacement_cost
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id;

-- 3) Inventory for each of the stores

SELECT 
    inventory.store_id,
    film.rating,
    COUNT(inventory.film_id) AS total_films
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
GROUP BY
	inventory.store_id,
    film.rating;

-- 4) Review aggregate and average replacement cost by category to understand the risk if a category is no longer in demand. 

SELECT 
    inventory.store_id,
    category.name,
    SUM(film.replacement_cost) AS Total_replacement_cost,
    AVG(film.replacement_cost) AS Average_replacement_cost,
    COUNT(inventory.film_id) AS Total_films
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
	LEFT JOIN film_category
		ON inventory.film_id = film_category.film_id
	LEFT JOIN category
		ON film_category.category_id = category.category_id
GROUP BY
	inventory.store_id,
    category.name;

-- 5) Understanding our customer database: a) if they are active b) which store do they frequent c) full address: street address, city and country 

SELECT 
    customer.first_name,
    customer.last_name,
    customer.active,
    customer.store_id,
    address.address,
    city.city,
    country.country
FROM customer
	LEFT JOIN address
		ON customer.address_id = address.address_id
	LEFT JOIN city
		ON address.city_id = city.city_id
	LEFT JOIN country
		ON city.country_id = country.country_id;

-- 6) Understanding total customer spend with us and pinpoint most valuable customers : a) if they are active b) which store do they frequent c) full address: street address, city and country 

SELECT 
    customer.first_name,
    customer.last_name,
    COUNT(rental.rental_id) AS Total_rentals,
    SUM(payment.amount) AS Total_lifetime_value
FROM customer
	LEFT JOIN payment
		ON customer.customer_id = payment.customer_id
	LEFT JOIN rental
		ON payment.rental_id = rental.rental_id
GROUP BY
	customer.first_name,
    customer.last_name
ORDER BY
	Total_lifetime_value DESC;

-- 7) List of advisor and investor names. 

SELECT
	'Advisor' AS type,
    first_name,
    last_name,
    '' AS Company_name
    
FROM advisor

UNION

SELECT
	'Investor' AS type,
    first_name,
    last_name,
    company_name
FROM investor;

	
-- 8) Actors with 3 awards - for what percentage of them do we carry a movie with them in it. Same question for actors with only 2 awards and 1 award. 

SELECT 
CASE
	WHEN actor_award.awards = "Emmy, Oscar, Tony " THEN 3
    WHEN actor_award.awards = "Emmy" THEN 1
    WHEN actor_award.awards = "Tony" THEN 1
    WHEN actor_award.awards = "Oscar" THEN 1
    ELSE 2
END AS Number_of_awards,
AVG(CASE WHEN actor_award.actor_id is NULL THEN 0 ELSE 1 END) AS pct_film
FROM 
	actor_award
GROUP BY
Number_of_awards
    

	

    
