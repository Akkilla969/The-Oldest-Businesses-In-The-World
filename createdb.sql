CREATE TABLE categories (
  category_code VARCHAR(5) PRIMARY KEY,
  category VARCHAR(50)
);

CREATE TABLE countries (
  country_code CHAR(3) PRIMARY KEY,
  country VARCHAR(50),
  continent VARCHAR(20)
);

CREATE TABLE businesses (
  business VARCHAR(64) PRIMARY KEY,
  year_founded INT,
  category_code VARCHAR(5),
  country_code CHAR(3)
);

\copy categories FROM 'categories.csv' DELIMITER ',' CSV HEADER;
\copy countries FROM 'countries.csv' DELIMITER ',' CSV HEADER;
\copy businesses FROM 'businesses.csv' DELIMITER ',' CSV HEADER;

-- Select the oldest and newest founding years from the businesses table
SELECT
    MIN(year_founded),
    MAX(year_founded)
FROM businesses;

-- Get the count of rows in businesses where the founding year was before 1000

SELECT COUNT (business)
FROM businesses
WHERE year_founded < 1000;
  
-- Select all columns from businesses where the founding year was before 1000
-- Arrange the results from oldest to newest

SELECT *
FROM businesses
WHERE year_founded <1000
ORDER BY year_founded;

-- Select business name, founding year, and country code from businesses; and category from categories
-- where the founding year was before 1000, arranged from oldest to newest

SELECT b.business, 
       b.year_founded, 
       b.country_code,
       c.category
FROM businesses b
JOIN categories c
ON c.category_code = b.category_code
WHERE b.year_founded < 1000
ORDER BY b.year_founded;

-- Select the category and count of category (as "n")
-- arranged by descending count, limited to 10 most common categories

SELECT
    c.category,
    COUNT(1) AS n
FROM categories c
JOIN businesses b ON c.category_code = b.category_code
GROUP BY c.category
ORDER BY COUNT(1) DESC
LIMIT 10;

-- Select the oldest founding year (as "oldest") from businesses, 
-- and continent from countries
-- for each continent, ordered from oldest to newest 

SELECT MIN(b.year_founded) AS oldest,
       c.continent
FROM businesses b
JOIN countries c
ON c.country_code = b.country_code
GROUP BY c.continent
ORDER BY MIN(b.year_founded);

-- Select the business, founding year, category, country, and continent

SELECT b.business, b.year_founded, 
       ca.category,
       co.country,
       co.continent
FROM businesses b
JOIN countries co ON b.country_code = co.country_code
JOIN categories ca ON b.category_code = ca.category_code;

-- Count the number of businesses in each continent and category

SELECT co.continent, ca.category,
       COUNT(business) AS n
FROM businesses b
JOIN categories ca ON b.category_code = ca.category_code
JOIN countries co ON b.country_code = co.country_code
GROUP BY co.continent, ca.category;

-- Repeat that previous query, filtering for results having a count greater than 5

SELECT co.continent, ca.category,
       COUNT(business) AS n
FROM businesses b
JOIN categories ca ON b.category_code = ca.category_code
JOIN countries co ON b.country_code = co.country_code
GROUP BY co.continent, ca.category
HAVING COUNT(business) > 5
ORDER BY COUNT(business) DESC;
