-- Netflix Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

SELECT * FROM netflix;

-- Business Problems:-

-- 1. Count the number of Movies vs TV Shows

SELECT type , COUNT(show_id) FROM netflix 
GROUP BY type

-- 2.Find the most common rating for Movies and TV Shows
SELECT 
	type,
	rating
FROM
	(
SELECT 
	type,
	rating,
	COUNT(*) ,
	RANK () OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
FROM netflix
GROUP BY 1, 2
) as t1
WHERE 
	ranking = 1

-- 3.List all movies released in a specific year (e.g. 2020)

SELECT * FROM netflix
WHERE release_year = 2020 AND type = 'Movie'

-- 4. Find the top 5 countries with the most content on Netflix

SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(country , ','))) as new_country ,
	COUNT (show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 5. Identify the longest Movie?

SELECT * FROM netflix

-- 6. Find the content added in the last 5 years

SELECT 
	 *
FROM netflix
WHERE TO_DATE(date_added , 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV Shows by director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'

-- 8. List all the shows with more than 5 seasons.

SELECT *, 
SPLIT_PART(duration , ' ' , 1)::numeric as seasons
FROM netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration , ' ' , 1)::numeric > 5

-- 9. Count the number of content items in each genre

SELECT COUNT(*) ,
TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) as genre
FROM netflix
GROUP BY genre

-- 10.

-- 11. List all the movies which are documentaries.

SELECT * FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%'

-- 12. Find all the content without a director

SELECT * FROM netflix
WHERE director IS NULL

-- 13. Find how many movies actor 'Salman Khan' has appeared in last 10 years.

SELECT * FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT COUNT(*) , TRIM(UNNEST(STRING_TO_ARRAY(casts , ','))) as actors
FROM netflix 
WHERE country LIKE '%India%'
GROUP BY 2
ORDER BY 1 DESC 
LIMIT 10

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.
-- Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

WITH new_categorization AS 
(
SELECT *, CASE WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad' ELSE 'Good' END as category
FROM netflix
)
SELECT category , COUNT(*)
FROM new_categorization 
GROUP BY 1





