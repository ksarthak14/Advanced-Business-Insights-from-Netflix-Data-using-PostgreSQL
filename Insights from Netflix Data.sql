--Netflix--

create table if not exists netflix(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(210),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);

-- 13 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
select type,count(*) as count
from netflix 
group by type;

--2. Find the most highest rating for movies and TV shows
select type, max(rating) 
from netflix
group by type;

--3. List all movies released in a specific year (e.g., 2020)
select * from netflix 
where type='Movie' and release_year=2020;

--4. Find the top 5 countries with the most content on Netflix
select UNNEST(STRING_TO_ARRAY(country,',')) as new_country,count(show_id) as total_content
from netflix
group by new_country
order by total_content desc limit 5;

--5. Identify the longest movie
select title,duration from netflix
where type = 'Movie'and duration=(select max(duration) from netflix);

--6. Find content added in the last 6 years
select * from netflix
where TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '6 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select type, director from netflix
where director LIKE'%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons
select * from netflix
where type= 'TV Show' and SPLIT_PART(duration,' ',1)::INTEGER>5;

--9. Count the number of content items in each genre
select UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,count(show_id) as total_content
from netflix
group by genre;

--10. List all movies that are documentaries
select * from netflix
where type = 'Movie' and listed_in LIKE '%Documentaries%';

--11. Find all content without a director
select * from netflix
where director is null;

--12. Find how many movies actor 'Salman Khan' appeared in last 11 years!
select * from netflix
where casts ilike '%Salman Khan%' and 
release_year>EXTRACT(YEAR FROM CURRENT_DATE)-11;

--13. Categorize the content based on the presence of the keywords 'kill' and 'violence' in  the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'.
select *, 
case 
when description ilike '%kill%' or description ilike '%violence%' then 'Bad_Content'
else 'Good_Content'
end as Category
from netflix;