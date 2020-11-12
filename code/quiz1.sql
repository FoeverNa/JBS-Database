#1번
USE sakila;

SELECT country, COUNT(country)
FROM customer_list
GROUP BY country
HAVING country = "India";

#2번
USE world;

SELECT name,  population
FROM city
WHERE (countrycode = "KOR" AND population >= 1000000)
ORDER BY population DESC;

#3번
SELECT name, countrycode, population
FROM city
WHERE population BETWEEN 8000000 AND 10000000
ORDER BY population DESC;

#4번
SELECT code, CONCAT(name,"(", indepyear,")") as NameIndep, continent, population
FROM country
WHERE indepyear BETWEEN 1940 AND 1950
ORDER BY indepyear;

#5번
SELECT CountryCode, Language, Percentage
FROM countrylanguage
WHERE Percentage >= 95 AND Language IN ("English", "Korean", "Spanish") 
ORDER BY Percentage DESC;

#6번
SELECT code, name, continent, Governmentform, population
FROM country
WHERE code LIKE "A%" AND governmentform LIKE "%Republic%";

#7번
USE sakila;

SELECT first_name, COUNT(first_name)
FROM actor
GROUP BY first_name
HAVING first_name = "DAN";

#8번
SELECT *
FROM film_text
WHERE title LIKE "%ICE%" AND description LIKE "%Drama%";

#9번
SELECT title, description, category, length, price
FROM film_list
WHERE price BETWEEN 1 AND 4 AND length >= 180 AND category NOT IN("Sci-Fi","Animation");


