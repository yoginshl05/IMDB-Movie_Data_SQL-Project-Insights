 USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    'director_mapping' as Table_Name, COUNT(*) as Row_Count
FROM director_mapping 
UNION 
SELECT 
    'genre' as Table_Name, COUNT(*) as Row_Count
FROM genre
UNION
SELECT 
      'movie' as Table_Name, COUNT(*) as Row_Count
FROM movie
UNION 
SELECT 
      'names' as Table_Name, COUNT(*) as Row_Count
FROM names
UNION
SELECT 
      'ratings' as Table_Name, COUNT(*) as Row_Count
FROM ratings
UNION
SELECT 
      'role_mapping' as Table_Name, COUNT(*) as Row_Count
FROM role_mapping;


SELECT 
      table_name, table_rows
FROM information_schema.tables
WHERE table_schema = 'imdb';

SELECT 
-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	   SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_Null_count,
       SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_Null_count,
       SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_Null_count,
       SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_Null_count,
       SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_Null_count,
       SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_Null_count,
       SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_Null_count,
       SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_Null_count,
       SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company
FROM movie;


SELECT 
      'id' as Column_Name, COUNT(*) AS Null_Count
FROM movie
WHERE id IS NULL
UNION 
SELECT 
      'title' as Column_Name, COUNT(*) AS Null_Count
FROM movie
WHERE title IS NULL
UNION
SELECT 'year' as Column_Name, COUNT(*) AS Null_count
FROM movie
WHERE year IS NULL
UNION
SELECT 'date_published' as Column_Name, COUNT(*) AS Null_count
FROM movie
WHERE date_published IS NULL
UNION
SELECT 'duration' as Column_Name, COUNT(*) AS Null_count
FROM movie
WHERE duration IS NULL
UNION
SELECT 'country' as Column_Name, COUNT(*) AS Null_count
FROM movie
WHERE country IS NULL
UNION
SELECT 'worlwide_gross_income' as Column_Name, COUNT(*) AS Null_count
FROM movie
WHERE worlwide_gross_income IS NULL
UNION
SELECT 'languages' as Column_Name, COUNT(*) AS Null_count
FROM movie
WHERE languages IS NULL
UNION
SELECT 'production_company' as Column_Name, COUNT(*) AS Null_count
FROM movie
WHERE production_company IS NULL
ORDER BY Null_Count DESC;      




-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total No. of movies released each year:

SELECT 
      year as Year, count(*) as number_of_movies
FROM movie
GROUP BY Year
ORDER BY Year;

-- Total No. movies released monthwise:
SELECT
       month(date_published) as month_num, count(*) as number_of_movies
FROM movie
GROUP BY month_num
ORDER BY number_of_movies DESC;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
       year as Year,
       COUNT(id) as num_of_movies
FROM movie
WHERE country = "USA" OR country = "India"
HAVING year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
	  DISTINCT genre
FROM genre
ORDER BY genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
      genre, COUNT(*) as No_of_Movies
FROM genre as g
JOIN movie as m
ON g.movie_id = m.id
GROUP BY genre
ORDER BY No_of_Movies DESC;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count AS (
                     SELECT
                           movie_id, COUNT(genre) as count_of_genre
                     FROM genre
                     GROUP BY movie_id
                     )
SELECT 
      COUNT(movie_id)
FROM genre_count
WHERE count_of_genre = 1;

SELECT * 
FROM genre;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
      genre, AVG(duration) AS avg_duration
FROM genre as g
JOIN movie as m
ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;


SELECT id, title, duration,
      CASE WHEN duration>120 THEN 'Long'
      ELSE 'Short'
      END AS is_long_movie
FROM movie
ORDER BY duration DESC;


SELECT
      id,
      title,
      duration,
      CASE 
          WHEN duration>200 THEN 'Long'
          WHEN duration>150 THEN 'Medium'
          ELSE 'Short'
          END as movie_length
FROM movie
ORDER BY duration DESC;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)



/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
       genre,
       count(movie_id) as movie_count,
       Rank() OVER(ORDER BY (count(movie_id)) DESC) as genre_rank
FROM genre
GROUP BY genre
ORDER BY genre_rank;
      
 

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	  MIN(avg_rating) as min_avg_rating,
      MAX(avg_rating) as max_avg_rating,
      MIN(total_votes) as min_total_votes,
      MAX(total_votes) as max_total_votes,
      MIN(median_rating) as min_median_rating,
      MAX(median_rating) as max_median_rating
FROM ratings;

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT 
       title,
       avg_rating,
       Rank() OVER(ORDER BY avg_rating DESC) as movie_rank
FROM movie as m
JOIN ratings as r
ON m.id = r.movie_id
GROUP BY title
ORDER BY movie_rank;


SELECT 
       title,
       avg_rating,
       Dense_Rank() OVER(ORDER BY avg_rating DESC) as movie_rank
FROM movie as m
JOIN ratings as r
ON m.id = r.movie_id
GROUP BY title
ORDER BY movie_rank;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
      median_rating,
      count(*) as movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
       production_company,
       count(*) as movie_count,
       Dense_Rank() OVER(ORDER BY count(*) DESC) as prod_company_rank
FROM movie as m
JOIN ratings as r
ON m.id = r.movie_id
WHERE avg_rating > 8
GROUP BY production_company
ORDER BY prod_company_rank;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
       g.genre,
       COUNT(m.id) as movie_count
FROM movie as m
JOIN genre as g ON m.id = g.movie_id
JOIN ratings as r ON m.id = r.movie_id
WHERE m.date_published BETWEEN "2017-03-01" AND "2017-03-31"
AND m.country = 'USA'
AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
      m.title,
      r.avg_rating,
      g.genre
FROM movie as m
JOIN genre as g ON m.id = g.movie_id
JOIN ratings as r ON m.id = r.movie_id
WHERE m.title LIKE "The%"
AND r.avg_rating > 8
GROUP BY m.title
ORDER BY r.avg_rating DESC;
      
      
      
-- 'median rating' column is added in above result.

SELECT 
      m.title,
      r.avg_rating,
      r.median_rating
FROM movie as m
JOIN genre as g ON m.id = g.movie_id
JOIN ratings as r ON g.movie_id = r.movie_id
WHERE m.title LIKE 'The%'
AND r.avg_rating > 8
GROUP BY m.title
ORDER BY r.median_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. No. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
      COUNT(*) as No_of_Movies
FROM movie as m
JOIN ratings as r
ON m.id = r.movie_id
WHERE date_published BETWEEN "2018-04-01" AND "2019-04-01"
AND r.median_rating > 8;



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
      m.country,
      SUM(r.total_votes) AS Vote_Count
FROM movie as m
JOIN ratings AS r
ON m.id = r.movie_id
WHERE m.country IN ('Germany', 'Italy')
GROUP BY m.country
ORDER BY r.total_votes DESC;







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
      SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
      SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
      SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
      SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH Top_3_genres AS
                    ( SELECT 
                             g.genre,
                             COUNT(*) AS movie_count
					  FROM genre AS g
                      JOIN ratings AS r ON g.movie_id = r.movie_id
                      WHERE avg_rating > 8
                      GROUP BY genre
                      ORDER BY movie_count DESC
                      LIMIT 3
                      )
                      
SELECT 
		n.name AS director_name,
	    COUNT(d.movie_id) AS movie_count
FROM director_mapping As d
JOIN genre AS g
USING (movie_id)
JOIN names AS n
ON n.id = d.name_id
JOIN ratings AS r
USING (movie_id)
WHERE r.avg_rating > 8 AND genre IN (SELECT genre FROM Top_3_genres)
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
       n.name AS actor_name,
       COUNT(rm.movie_id) AS movie_count
FROM role_mapping AS rm
JOIN names AS n 
ON rm.name_id = n.id
JOIN ratings AS r 
USING (movie_id)
WHERE median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT  
       production_company,
       SUM(total_votes) AS vote_count,
       RANK() OVER( ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY production_company
ORDER BY vote_count DESC;



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT * FROM role_mapping;

SELECT DISTINCT category FROM role_mapping;

SELECT * FROM names;
SELECT DISTINCT country FROM movie;

-- GET the movies released in India along with actor_name and avg_rating
WITH ActorFromIndia AS (
SELECT 
      n.id as actor_id,
      n.name as actor_name,
      m.id as movie_id,
      m.title as movie_name,
      r.avg_rating,
      r.total_votes
FROM names as n
JOIN role_mapping as rm ON n.id = rm.name_id
JOIN movie as m ON rm.movie_id = m.id
JOIN ratings as r ON m.id = r. movie_id
WHERE m.country = 'India'
),

-- Getting actors with atleast 5 movies with their names and weighted average (actor_avg_rating)

ActorRatingSummary AS (
SELECT 
      actor_id,
      actor_name,
      COUNT(movie_id) AS movie_count,
      SUM(avg_rating * total_votes) / SUM(total_votes) AS actor_avg_rating,
      SUM(total_votes) AS Total_votes
FROM ActorFromIndia
GROUP BY actor_id, actor_name
HAVING movie_count >= 5
)

-- Getting the output in desired format.

SELECT 
       actor_name,
       Total_votes,
       movie_count,
       actor_avg_rating,
       RANK() OVER (ORDER BY actor_avg_rating DESC, Total_votes DESC) AS actor_rank
FROM ActorRatingSummary
ORDER BY actor_rank ASC
LIMIT 1;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Getting the actress from India along with movie names, ratings and avg_rating

WITH ActressFromIndia AS (

SELECT 
      n.id AS actress_id,
      n.name AS actress_name,
      m.id AS movie_id,
      m.title AS movie_name,
      r.total_votes,
      r.avg_rating
FROM names AS n
JOIN role_mapping AS rm ON n.id = rm.name_id
JOIN movie AS m ON rm.movie_id = m.id
JOIN ratings AS r ON m.id = r.movie_id
WHERE rm.category = "actress" AND m.country = "India"
),

-- Getting the Actress with at least 3 indian movies along with their weighted avergaes.

ActressRatingSummary AS (

SELECT 
       actress_id,
       actress_name,
       COUNT(movie_id) AS movie_count,
       SUM(avg_rating * total_votes) / SUM(total_votes) AS actress_avg_rating,
       SUM(total_votes) AS total_votes
FROM ActressFromIndia
GROUP BY actress_id, actress_name
HAVING movie_count >= 3
)
-- Getting the final output in desired manner.

SELECT 
      actress_name,
      total_votes,
      movie_count,
      actress_avg_rating,
      RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM ActressRatingSummary
GROUP BY actress_name
ORDER BY actress_rank ASC
LIMIT 5;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT DISTINCT genre FROM genre;

-- Getting the Avg Rating of movies in Thriller genre

WITH ThrillerMovieRating AS (

SELECT 
       m.title AS movie_name,
       g.genre AS movie_genre,
       r.avg_rating AS movie_rating
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN ratings AS r ON g.movie_id = r.movie_id
WHERE g.genre = "Thriller"
)
-- Classifying Thriller movies as per box office result.

SELECT 
      movie_name,
      movie_genre,
      movie_rating,
      CASE 
		   WHEN movie_rating > 8 THEN "Superhit movies"
           WHEN movie_rating BETWEEN 7 AND 8 THEN "Hit movies"
           WHEN movie_rating BETWEEN 5 AND 7 THEN "One-Time Watch movies"
           ELSE "Flop movies"
           END AS box_office_result
FROM ThrillerMovieRating
GROUP BY movie_name
ORDER BY movie_rating DESC;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Getting Average Duration for all genres.

WITH GenreAverage AS (

SELECT 
	  g.genre AS genre,
      AVG(duration) AS avg_duration
FROM genre AS g 
JOIN movie AS m ON g.movie_id = m.id
GROUP BY genre
)

-- Getting running_total_duration and moving_avg_duration

SELECT 
	  genre,
      avg_duration,
      ROUND(SUM(avg_duration) OVER (ORDER BY genre),2) AS running_total_duration,
      ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_duration
FROM GenreAverage
GROUP BY genre;




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+------------------ ---+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Getting Top 3 Genre

WITH TOP3Genere AS (

SELECT 
       genre,
       COUNT(movie_id) AS movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),

-- Rank movies my worldwide_gross_income within each year and genre

Ranked_movies AS(
SELECT 
       g.genre AS genre,
	   m.year AS year,
	   m.title AS movie_name,
       m.worlwide_gross_income,
       ROW_NUMBER() OVER (PARTITION BY g.genre, m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
FROM movie AS m
JOIN genre AS g ON m.id = g.movie_id
JOIN TOP3Genere AS tg ON g.genre = tg.genre
)

-- Final query to get top 5 movies for each year and genre

SELECT 
       genre,
       year,
       movie_name,
       worlwide_gross_income,
       movie_rank
FROM Ranked_movies
WHERE movie_rank <=5
ORDER BY genre, year, movie_rank;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Select movies with rating >8 and multilingual

WITH hit_movies AS (

      SELECT 
             production_company
	   FROM movie AS m
       JOIN ratings AS r ON m.id = r.movie_id
       WHERE POSITION(',' IN languages)>0 AND median_rating >=8 AND production_company IS NOT NULL
),

-- Count no. of hits for each production company

company_hit_count AS (

        SELECT 
               production_company,
               COUNT(*) AS movie_count
		FROM hit_movies
        GROUP BY production_company
),

-- Ranking Production companies by no. of hits

ranked_companies AS(

       SELECT 
              production_company,
              movie_count,
              RANK() OVER(ORDER BY movie_count DESC) AS prod_comp_rank
	   FROM company_hit_count
)

SELECT 
      production_company,
      movie_count,
      prod_comp_rank
FROM ranked_companies
WHERE prod_comp_rank <=2
ORDER BY prod_comp_rank;


SELECT 
        production_company,
		COUNT(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
        
FROM movie AS m 
JOIN ratings AS r 
ON m.id=r.movie_id
WHERE median_rating>=8 AND production_company IS NOT NULL AND POSITION(',' IN languages)>0
GROUP BY production_company
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
       name AS actress_name,
       total_votes,
       COUNT(rm.movie_id) AS movie_count,
       avg_rating AS actress_avg_rating,
       ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS acress_rank
FROM names AS n
JOIN role_mapping AS rm 
ON n.id = rm.name_id
JOIN ratings AS r
ON rm.movie_id = r.movie_id
JOIN genre AS g
ON r.movie_id = g.movie_id
WHERE category = 'actress' AND avg_rating > 8 AND genre = 'drama'
GROUP BY name
LIMIT 3;


SELECT * FROM director_mapping;

SELECT * FROM names;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT     
                      d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       
           director_mapping AS d
           JOIN names AS n
           ON    n.id = d.name_id
		   JOIN movie AS m
           ON     m.id = d.movie_id
           JOIN ratings AS r
           ON    r.movie_id = m.id ), 
           
           
top_director_summary AS
(
	SELECT *,
		   Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
       
SELECT   name_id AS director_id,
         NAME AS director_name,
         Count(movie_id)  AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)  AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating)  AS min_rating,
         Max(avg_rating)  AS max_rating,
         Sum(duration)    AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC 
LIMIT 9;


SELECT     
                      d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       
           director_mapping AS d
           JOIN names AS n
           ON    n.id = d.name_id
		   JOIN movie AS m
           ON     m.id = d.movie_id
           JOIN ratings AS r
           ON    r.movie_id = m.id ;