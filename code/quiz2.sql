use world;

#1번
SELECT COUNT(DISTINCT continent)as count
FROM country;

#2번
SELECT countrycode, COUNT(countrycode) AS count 
FROM city
GROUP BY countrycode
ORDER BY count DESC
LIMIT 5;

#3번
SELECT continent, COUNT(continent) AS count
FROM country
GROUP BY continent
ORDER BY count DESC;

#4번
SELECT continent, COUNT(continent) AS count, STDDEV(gnp) AS std_gnp
FROM country
WHERE population >= 10000000
GROUP BY continent
ORDER BY std_gnp DESC;

#5번
SELECT countrycode, SUM(population) as sum_pop
FROM city
GROUP BY countrycode
HAVING sum_pop > 50000000
ORDER BY sum_pop DESC;

#6번
SELECT language, COUNT(language) as count
FROM countrylanguage
GROUP BY language
ORDER BY count DESC
LIMIT 5, 5;

#7번
SELECT language, COUNT(language) AS count
FROM countrylanguage
GROUP BY language
HAVING count >= 15
ORDER BY count DESC;

#8번
SELECT continent, SUM(surfacearea) AS sum
FROM country
GROUP BY continent
ORDER BY sum DESC;

