use company_db;
-- 1.Display all columns.
select * from netflix_titles1;

-- 2.Find the total number of Movies and TV Shows available in the dataset.
select type,count(*)
from netflix_titles1
group by type;

-- 3.Categorize content into Adult (TV-MA) and Family (all other ratings) and count how many titles belong to each category.
SELECT 
CASE 
WHEN rating='TV-MA' THEN 'Adult'
ELSE 'Family'
END AS category,
COUNT(*)
FROM netflix_titles1
GROUP BY category;

-- 4.Find the number of Movies in each country, but show only countries that have more than 1 movie.
SELECT country, COUNT(*)
FROM netflix_titles1
WHERE type='Movie'
GROUP BY country
HAVING COUNT(*) > 1;

-- 5.Find the latest (maximum) release year separately for Movies and TV Shows.
SELECT type,MAX(release_year) AS maximum_year
FROM netflix_titles1
GROUP BY type;

-- 6.Find the oldest release year for each title in the dataset.
SELECT type,MIN(release_year)AS minimum_year
FROM netflix_titles1
GROUP BY type;

-- 7.Count how many titles exist for each rating, and sort results from highest to lowest count.
SELECT rating,COUNT(*) As Count_rating
FROM netflix_titles1
GROUP BY rating
ORDER BY COUNT(*) DESC;

-- 8.Count how many titles were released per year, but show only years after 2020.
SELECT release_year, COUNT(*)as Num_movie
FROM netflix_titles1
GROUP BY release_year
HAVING release_year >= 2020;

-- 9.Show titles of movies longer than 100 minutes.
SELECT title, duration
FROM netflix_titles1
WHERE CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) > 100;

-- 10.Count how many titles belong to each listed category (listed_in).
SELECT listed_in, COUNT(*)as Count_list
FROM netflix_titles1
GROUP BY listed_in;

-- 11.Find countries that contain only TV Shows and no Movies.
SELECT country
FROM netflix_titles1
GROUP BY country
HAVING SUM(type='Movie') = 0;

-- 12.Find movies that have duration greater than the average movie duration.
SELECT title
FROM netflix_titles1
WHERE type='Movie'
AND CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) >
(
SELECT AVG(CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED))
FROM netflix_titles1
WHERE type='Movie'
);

-- 13.Show all titles released in the latest release year available in the dataset.
SELECT *
FROM netflix_titles1
WHERE release_year =
(SELECT MAX(release_year) FROM netflix_titles1);


-- 14.Find the most common rating used in the dataset. 
SELECT rating
FROM netflix_titles1
GROUP BY rating
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 15.Find titles released in the year that has the highest number of releases.
SELECT title
FROM netflix_titles1
WHERE release_year =
(
SELECT release_year
FROM netflix_titles1
GROUP BY release_year
ORDER BY COUNT(*) DESC
LIMIT 1
);

-- 16.Find the longest movie in the dataset.
SELECT title,duration
FROM netflix_titles1
WHERE CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) =
(
SELECT MAX(CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED))
FROM netflix_titles1
WHERE type='Movie'
);

-- 17.Find the earliest released TV Show.
SELECT *
FROM netflix_titles1
WHERE type='TV Show'
AND release_year =
(
SELECT MIN(release_year)
FROM netflix_titles1
WHERE type='TV Show'
);

-- 18.Find ratings that are used more than the average number of times.
SELECT rating, COUNT(*)
FROM netflix_titles1
GROUP BY rating
HAVING COUNT(*) >
(
SELECT AVG(cnt)
FROM (
SELECT COUNT(*) cnt
FROM netflix_titles1
GROUP BY rating
) x
);

-- 19.Show titles released in the top 3 years with the highest number of releases.
WITH top_years AS (
SELECT release_year
FROM netflix_titles1
GROUP BY release_year
ORDER BY COUNT(*) DESC
LIMIT 3
)
SELECT *
FROM netflix_titles1
WHERE release_year IN (SELECT release_year FROM top_years);

-- 20.Find the country that has the maximum number of titles.
SELECT country,COUNT(*)
FROM netflix_titles1
GROUP BY country
HAVING COUNT(*) =
(
SELECT MAX(cnt)
FROM (
SELECT COUNT(*) cnt
FROM netflix_titles1
GROUP BY country
) t
);


-- 21.Using CTE, count the total number of Movies and TV Shows.
WITH cte AS (
SELECT type, COUNT(*) cnt
FROM netflix_titles1
GROUP BY type
)
SELECT *
FROM cte;

-- 22.Using CTE, extract movie duration in minutes and sort movies from longest to shortest.
WITH movie_cte AS (
SELECT title,
CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED)AS minutes
FROM netflix_titles1
WHERE type='Movie'
)

SELECT *
FROM movie_cte
ORDER BY minutes DESC;

-- 23.Movies released between 2015 and 2020.
SELECT *
FROM netflix_titles1
WHERE type='Movie'
AND release_year BETWEEN 2015 AND 2020;

-- 24.TV Shows from India after 2018.
SELECT *
FROM netflix_titles1
WHERE type='TV Show'
AND country='India'
AND release_year > 2018;

-- 25.Titles containing word "Love".
SELECT *
FROM netflix_titles1
WHERE title LIKE '%Love%';

-- 26.Titles added in September.
SELECT *
FROM netflix_titles1
WHERE date_added LIKE 'September%';

-- 27.Records where country is available.
SELECT *
FROM netflix_titles1
WHERE country IS NOT NULL;

-- 28.Replace NULL director.
SELECT title,
IFNULL(director,'No Director') AS director
FROM netflix_titles1;

-- 29.Average duration rounded.
SELECT ROUND(AVG(CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED)),2)
FROM netflix_titles1
WHERE type='Movie';

-- 30.Calculate the percentage of movies in the dataset.
SELECT 
COUNT(CASE WHEN type='Movie' THEN 1 END)*100.0/COUNT(*) AS movie_percent
FROM netflix_titles1;


-- 31.Find the maximum movie duration for each release year.
SELECT release_year,
MAX(CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED))As max_duration
FROM netflix_titles1
GROUP BY release_year;

-- 32.Categorize titles as New (>=2020), Recent (2015-2019), Old (<2015).
SELECT title,
CASE 
WHEN release_year >= 2020 THEN 'New'
WHEN release_year BETWEEN 2015 AND 2019 THEN 'Recent'
ELSE 'Old'
END
FROM netflix;

-- 33.Categorize rating into Kids / Teen / Adult.
SELECT title,
CASE
WHEN rating IN ('G','TV-G','TV-Y') THEN 'Kids'
WHEN rating IN ('PG','PG-13','TV-14') THEN 'Teen'
ELSE 'Adult'
END AS category
FROM netflix_titles1;

-- 34.Count the Country available or missing.
SELECT title,
CASE 
WHEN country IS NULL THEN 'Missing'
ELSE 'Available'
END AS Count_country
FROM netflix_titles1;

-- 35.Categorize Long vs Short movies.
SELECT title,
CASE
WHEN CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) > 120 
THEN 'Long Movie'
ELSE 'Short Movie'
END
FROM netflix_titles1
WHERE type='Movie';

-- 36.Countries having both Movies and Shows.
SELECT country
FROM netflix_titles1
GROUP BY country
HAVING COUNT(DISTINCT type) = 2;

-- 37.Categories containing more than 2 titles.
SELECT listed_in, COUNT(*)
FROM netflix_titles1
GROUP BY listed_in
HAVING COUNT(*) > 2;

-- 38.Directors with more than 1 title.
SELECT director, COUNT(*)
FROM netflix_titles1
WHERE director IS NOT NULL
GROUP BY director
HAVING COUNT(*) > 1;

-- 39.Retrieve records where "Blood & Water" is released after 2020 or "Kota Factory" is released before 2021 and not from India.
select * from netflix_titles1
where release_year > 2020 and title = "Blood & Water" OR release_year < 2021 and title = 'Kota Factory' and not country = 'India'; 

-- 40.Retrieve unique titles from netflix_titles1 and display them in alphabetical order.
select distinct title from netflix_titles1
order by title;

-- 41.Find the minimum, maximum, total distinct count, average (rounded to 2 decimals), and sum of release years from netflix_titles1.
select min(release_year)as min_rel, max(release_year)as max_rel,
count(distinct release_year)as num_rel,round(avg(release_year),2)as avg_rel,
sum(release_year)as sum_rel from netflix_titles1;

-- 42.Count how many shows are from India, United States, and South Africa using conditional aggregation.
select sum(case when country='india' then 1 else 0 end)as Shows_in_india,
sum(case when country='United states' then 1 else 0 end)as Shows_in_US,
sum(case when country='South Africa' then 1 else 0 end)as Shows_in_SA
from netflix_titles1;

-- 43.Count how many titles are rated TV-MA, PG-13, and PG.
SELECT
SUM(CASE WHEN rating='TV-MA' THEN 1 ELSE 0 END) AS TV_MA,
SUM(CASE WHEN rating='PG-13' THEN 1 ELSE 0 END) AS PG_13,
SUM(CASE WHEN rating='PG' THEN 1 ELSE 0 END) AS PG
FROM netflix_titles1;

-- 44.Count titles released before 2010, between 2010–2020, and after 2020.
SELECT
SUM(CASE WHEN release_year < 2010 THEN 1 ELSE 0 END) AS Old_Content,
SUM(CASE WHEN release_year BETWEEN 2010 AND 2020 THEN 1 ELSE 0 END) AS Mid_Content,
SUM(CASE WHEN release_year > 2020 THEN 1 ELSE 0 END) AS New_Content
FROM netflix_titles1;

-- 45.Count titles with and without director information.
SELECT
SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS No_Director,
SUM(CASE WHEN director IS NOT NULL THEN 1 ELSE 0 END) AS Has_Director
FROM netflix_titles1;


-- 46.Count Movies and TV Shows released after 2018.
SELECT
SUM(CASE WHEN type='Movie' AND release_year>2018 THEN 1 ELSE 0 END) AS Movies_After_2018,
SUM(CASE WHEN type='TV Show' AND release_year>2018 THEN 1 ELSE 0 END) AS Shows_After_2018
FROM netflix_titles1;

-- 47.Count Movies longer than 120 min and less than 120 min.
SELECT
SUM(CASE 
WHEN type='Movie' 
AND CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) > 120 
THEN 1 ELSE 0 END) AS Long_Movies,

SUM(CASE 
WHEN type='Movie' 
AND CAST(SUBSTRING_INDEX(duration,' ',1) AS UNSIGNED) <= 120 
THEN 1 ELSE 0 END) AS Short_Movies
FROM netflix_titles1;

-- 48.Count content added in September, October, and November.
SELECT
SUM(CASE WHEN date_added LIKE 'September%' THEN 1 ELSE 0 END) AS September,
SUM(CASE WHEN date_added LIKE 'October%' THEN 1 ELSE 0 END) AS October,
SUM(CASE WHEN date_added LIKE 'November%' THEN 1 ELSE 0 END) AS November
FROM netflix_titles1;


-- 49.Count how many records have NULL director and NOT NULL director.
SELECT 
COUNT(*) AS total_records,
COUNT(director) AS director_present,
COUNT(*) - COUNT(director) AS director_missing
FROM netflix_titles1;

-- 50.Count how many titles contain the word "Crime" in category.
SELECT COUNT(*)
FROM netflix_titles1
WHERE listed_in LIKE '%Crime%';