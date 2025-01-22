select * from netflix;

1.Count the number of Movies vs TV Shows


		select type1, count(*)
		from netflix
		group by type1;

2. Find the most common rating for movies and TV shows

		with RankingOfRatings as (
			select type1, rating, count(*),
			rank() over(partition by type1 order by count(*) desc) as ranking
			from netflix
			group by 1 , 2
		) 
		select type1, rating 
		from RankingOfRatings
		where ranking = 1;


3. List all movies released in a specific year (e.g., 2020)

		select title
		from netflix
		where release_year=2020 and type1='Movie';



4. Find the top 5 countries with the most content on Netflix

		select 
		unnest(string_to_array(country, ',')) as new_country,
		count(*)
		from netflix
		group by new_country
		order by count(*) desc
		limit 5;




5. Identify the longest movie

		select * from netflix;


		select *
		from netflix
		where type1='Movie' and duration is not null
		order by split_part(duration, ' ',1)::int desc;


6. Find content added in the last 5 years

		SELECT *
		FROM netflix
		WHERE to_date(date_added, 'Month DD, YYYY' ) >= current_date - Interval '5 years';

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

		select * from netflix;

		select * 
		from netflix
		where director = 'Rajiv Chilaka';

8. List all TV shows with more than 5 seasons

		select * from netflix;

		select *
		from netflix
		where type1='TV Show' and split_part(duration, ' ',1)::int >5;


9. Count the number of content items in each genre

		select 
			unnest(string_to_array(listed_in, ',')) as genre,
			count(*)
		from netflix
		group by genre;

10.Find each year and the average numbers of content release in India on netflix.

		select 
		unnest(string_to_array(country,',')) as country,
		release_year, 
		count(*) as total_releases,
		round( count(*)/
		(select count(*) from netflix where country like '%India%'):: numeric* 100,2

		) as average_releases
		from netflix
		where country = 'India'
		group by country, release_year
		order by average_releases desc
		limit 5;
		

		

11. List all movies that are documentaries

		SELECT * 
		FROM netflix
		WHERE listed_in LIKE '%Documentaries%';


12. Find all content without a director

		select * from netflix;

		select *
		from netflix 
		where director is null;


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

		select *
		from netflix
		where casting like '%Salman Khan%' and to_date(date_added, 'MONTH DD, YYYY') >= current_date - Interval '10 years';

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

		select 
		trim(unnest(string_to_array(casting, ','))) as actor_names, count(*) as movies
		from netflix
		where country like '%India%'
		group by 1
		order by 2 desc
		limit 10;


15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


		select
		case 
			when description like '%kill%' or description like '%violence' then 'Bad'
			else 'Good'
		end as Category,
		count(*) as Movies
		from netflix
		group by Category;


16. Find the distribution of content types (Movies/TV Shows) by country.

		SELECT 
		    trim(unnest(string_to_array(country,','))) as country,
		    SUM(CASE WHEN type1 = 'Movie' THEN 1 ELSE 0 END) AS total_movies,
		    SUM(CASE WHEN type1 = 'TV Show' THEN 1 ELSE 0 END) AS total_tv_shows
		FROM 
	    netflix
		GROUP BY 1
		ORDER BY 1;

17. Identify the most common duration for Movies and TV Shows

		select 
		type1,
		duration,
		count(*),
		rank() over(partition by type1 order by count(*) desc) as rn
		from netflix
		group by 1 , 2;


18. Determine the top 5 genres with the highest number of titles.


		select * from netflix;

		select 
		unnest(string_to_array(listed_in,',')) as genre,
		count(*) 
		from netflix
		group by 1
		order by 2 desc
		limit 5;

19. Analyze the top 3 genres in each country by content count.

		select * from netflix;

		select * 
		from (
			select
			trim(unnest(string_to_array(country,','))) as country,
			trim(unnest(string_to_array(listed_in,','))) as genre,
			count(*),
			dense_rank() over(partition by trim(unnest(string_to_array(country,','))) order by count(*) desc) as rn
			from netflix
			group by 1,2 ) as x
	
		where x.country !='' and x.genre is not null and x.rn<=3;


20. Determine the country with the most diverse genres (based on unique genres).
		
		select * from netflix;


		select x.country,
		count(x.rn)
		from (
			select
			trim(unnest(string_to_array(country,','))) as country,
			trim(unnest(string_to_array(listed_in,','))) as genre,
			row_number() over(partition by trim(unnest(string_to_array(country,',')))) as rn
			from netflix
			group by 1,2
			order by 1 ) as x
		where x.country !='' and x.genre is not null
		group by 1; 		


