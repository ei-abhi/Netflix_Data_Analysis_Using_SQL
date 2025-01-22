# Netflix Movie and TV show_Data_Analysis_Using_SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type1         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casting       VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
    select type1, count(*)
		from netflix
		group by type1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
    with RankingOfRatings as (
			select type1, rating, count(*),
			rank() over(partition by type1 order by count(*) desc) as ranking
			from netflix
			group by 1 , 2
		) 
		select type1, rating 
		from RankingOfRatings
		where ranking = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
    select title
		from netflix
		where release_year=2020 and type1='Movie';
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
    select 
		unnest(string_to_array(country, ',')) as new_country,
		count(*)
		from netflix
		group by new_country
		order by count(*) desc
		limit 5;

```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql

		select *
		from netflix
		where type1='Movie' and duration is not null
		order by split_part(duration, ' ',1)::int desc;
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
    SELECT *
		FROM netflix
		WHERE to_date(date_added, 'Month DD, YYYY' ) >= current_date - Interval '5 years';

```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix;

		select * 
		from netflix
		where director = 'Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
    select *
		from netflix
		where type1='TV Show' and split_part(duration, ' ',1)::int >5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
		select 
			unnest(string_to_array(listed_in, ',')) as genre,
			count(*)
		from netflix
		group by genre;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
		SELECT * 
		FROM netflix
		WHERE listed_in LIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
		select *
		from netflix 
		where director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
    select *
		from netflix
		where casting like '%Salman Khan%' and to_date(date_added, 'MONTH DD, YYYY') >= current_date - Interval '10 years';

```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
		select 
		trim(unnest(string_to_array(casting, ','))) as actor_names, count(*) as movies
		from netflix
		where country like '%India%'
		group by 1
		order by 2 desc
		limit 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
		select
		case 
			when description like '%kill%' or description like '%violence%' then 'Bad'
			else 'Good'
		end as Category,
		count(*) as Movies
		from netflix
		group by Category;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

### 16. Find the distribution of content types (Movies/TV Shows) by country.

```sql
SELECT 
		    trim(unnest(string_to_array(country,','))) as country,
		    SUM(CASE WHEN type1 = 'Movie' THEN 1 ELSE 0 END) AS total_movies,
		    SUM(CASE WHEN type1 = 'TV Show' THEN 1 ELSE 0 END) AS total_tv_shows
		FROM 
	    netflix
		GROUP BY 1
		ORDER BY 1;
```

**Objective:** Distribution of Movies and TV Shows in each country

### 17. Identify the most common duration for Movies and TV Shows
```sql
select 
		type1,
		duration,
		count(*),
		rank() over(partition by type1 order by count(*) desc) as rn
		from netflix
		group by 1 , 2;
```

**Objective:** Identify the most common duration for Movies and TV Shows

### 18. Determine the top 5 genres with the highest number of titles.

```sql
select 
		unnest(string_to_array(listed_in,',')) as genre,
		count(*) 
		from netflix
		group by 1
		order by 2 desc
		limit 5;
```

**Objective:** Determine the top 5 genres with the highest number of titles.


### 19. Analyze the top 3 genres in each country by content count.
```sql
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
```

**Objective:** Analyze the top 3 genres in each country by content count.

### 20. Determine the country with the most diverse genres (based on unique genres).
```sql
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
		group by 1
    order by 2 desc
    limit 1; 		

```

**Objective:** Determine the country with the most diverse genres (based on unique genres)




## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Abhi

Thank you for your support, and I look forward to connecting with you!
