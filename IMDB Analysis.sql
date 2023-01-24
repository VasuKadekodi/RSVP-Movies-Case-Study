USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT TABLE_NAME, TABLE_ROWS
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';

/* Conclusion (total number of rows in each table of the schema)
		--------------------|-----------------
		TABLE_NAME			|		TABLE_ROWS
		--------------------|-----------------
		director_mapping	|		   3867
		genre				|		  14662
		movie				|		   7084
		names				|	      25857
		ratings				|          8230
		role_mapping		|	      16019						*/







-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT SUM(CASE WHEN id is null THEN 1 ELSE 0 END) AS 'id',
	SUM(CASE WHEN title is null THEN 1 ELSE 0 END) AS 'title',
    SUM(CASE WHEN year is null THEN 1 ELSE 0 END) AS 'year',
    SUM(CASE WHEN date_published is null THEN 1 ELSE 0 END) AS 'date_published',
    SUM(CASE WHEN duration is null THEN 1 ELSE 0 END) AS 'duration',
    SUM(CASE WHEN country is null THEN 1 ELSE 0 END) AS 'country',
    SUM(CASE WHEN worlwide_gross_income is null THEN 1 ELSE 0 END) AS 'worlwide_gross_income',
    SUM(CASE WHEN languages is null THEN 1 ELSE 0 END) AS 'languages',
    SUM(CASE WHEN production_company is null THEN 1 ELSE 0 END) AS 'production_company'
FROM movie;

/* Conclusion (columns in the movie table those countain null values)
    ------------------------|----------------------
	Column_name				|	Total_null_values
    ------------------------|----------------------
	id						|			0
	title 					|			0 
	year 					|			0 
	date_published 			|			0	 
	duration 				|			0 
	country 				|		   20 
	worlwide_gross_income	| 		 3724 
	languages 				|	 	  194 
	production_company		|	  	  528				*/


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

-- Year wise

SELECT year, 
		count(title) AS number_of_movies
FROM movie
GROUP BY year;

/* Conclusion(total number of movies released each year)
    ------------|--------------------------
	year		|		number_of_movies	
    ------------|--------------------------
	2017		|			3052
	2018		|			2944
	2019		|			2001
From above result we can see that there are more number of movies released in 2017. */


-- Month wise

SELECT month(date_published) AS month_num, 
		count(title) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

/* Conclusion (Month wise trend)
    --------------------|-------------------------
	month_num			|	number_of_movies
    --------------------|-------------------------
		1				|		804
		2				|		640
		3				|		824
		4				|		680
		5				|		625
		6				|		580
		7				|		493
		8				|		678
		9				|		809
		10				|		801
		11				|		625
		12				|		438				
From above result we can say that maximum number of movies are released in march month and least in december. */


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Count(DISTINCT id) AS number_of_movies, 
		year
FROM   movie
WHERE  ( country LIKE '%INDIA%' OR country LIKE '%USA%' )AND year = 2019;

/* Conclusion: 1059 movies were produced in the USA or India in the year 2019 */



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT distinct genre
FROM genre;

/* Conclusion (unique list of the genres present in the data set)
	Genre (There are 13 unique genres present in the data set as mentioned below)
----------------------------------------------------------------------------------
	Drama
	Fantasy
	Thriller
	Comedy
	Horror
	Family
	Romance
	Adventure
	Action
	Sci-Fi
	Crime
	Mystery
	Others			*/



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT  genre, 
		count(genre) AS number_of_movies
FROM movie m
JOIN genre g ON m.id=g.movie_id
GROUP BY genre
ORDER BY number_of_movies DESC;

/* Conclusion: Drama has the highest number (4285) of movies produced overall. 
--------------------|---------------------
    genre			|	number_of_movies
--------------------|---------------------
	Drama			|		4285
	Comedy			|		2412
	Thriller		|		1484
	Action			|		1289
	Horror			|		1208
	Romance			|		 906
	Crime			|		 813
	Adventure		|		 591
	Mystery			|		 555
	Sci-Fi			|		 375
	Fantasy			|		 342
	Family			|		 302
	Others			|		 100 		*/








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count 
AS	(
	SELECT movie_id, 
		   count(genre) as count_of_genre
	FROM genre 
    group by movie_id
    )

SELECT count(movie_id) 
FROM genre_count 
where count_of_genre = 1;
 
/* Conclusion: There are 3289 movies belong to only one genre  */


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

SELECT genre, 
		AVG(duration) AS average
FROM movie m
JOIN genre g ON m.id=g.movie_id
GROUP BY genre
ORDER BY average DESC;

/* Conclusion: Action movies genre tops the list with avg duration 112.8829.
    ----------------|------------------
		genre		|		average
    ----------------|------------------
		Action		|		112.8829
		Romance		|		109.5342
		Crime		|		107.0517
		Drama		|		106.7746
		Fantasy		|		105.1404
		Comedy		|		102.6227
		Adventure	|		101.8714
		Mystery		|		101.8000
		Thriller	|		101.5761
		Family		|		100.9669
		Others		|		100.1600
		Sci-Fi		|		 97.9413
		Horror		|		 92.7243 			*/


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

WITH rank_thriller
AS (
	SELECT  genre, 
			count(genre) AS number_of_movies, 
			RANK () OVER(ORDER BY count(genre) DESC) AS ranking
	FROM genre
	GROUP BY genre
    )

SELECT *
FROM rank_thriller
WHERE genre='thriller';

/* Conclusion: The rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced is 3 with 1484 movies. 
			   (Drama and Comedy got the 1st and 2nd place respectively with 4285 and 2412 number of movies.)  */


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
	min(avg_rating) AS min_avg_rating,
	max(avg_rating) AS max_avg_rating,
    min(total_votes) AS min_total_votes,
	max(total_votes) AS max_total_votes,
    min(median_rating) AS min_median_rating,
	max(median_rating) AS max_median_rating
FROM ratings;

/* Conclusion: Result shown in the table below.
----------------|-------------------|---------------------|----------------------|------------------|-----------------
 min_avg_rating	|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating	|max_median_rating
----------------|-------------------|---------------------|----------------------|------------------|-----------------
	1.0		   	|		10.0		|		100			  |		725138			 |			1		|		10			*/
    



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

SELECT title, 
		avg_rating, 
		RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank 
FROM movie m
JOIN ratings r ON m.id=r.movie_id 
LIMIT 10;

/* Conclusion: We found that 1st rank of a movie based on average rating is shared by 'Kirket' and 'Love in Kilnerry' with average rating 10. 
    ----------------------------|-----------------------|--------------
	       title				|		avg_rating		|	movie_rank
    ----------------------------|-----------------------|--------------
			Kirket				|			10.0		|		1
		Love in Kilnerry		|			10.0		|		1
		Gini Helida Kathe		|			 9.8		|		3
			Runam				|			 9.7		|		4
			 Fan				|			 9.6		|		5
Android Kunjappan Version 5.25	|		     9.6		|		5
	Yeh Suhaagraat Impossible	|			 9.5		|		7		
			Safe				|			 9.5		|		7
	  The Brighton Miracle		|			 9.5		|		7
			Shibu				|			 9.4		|	   10				*/
            



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

SELECT median_rating, 
		count(median_rating) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

/* Conclusion: Based on median rating we can see that most number of the movies got median rating as 7 i.e. 2257.
    --------------------|--------------------
	median_rating		|		movie_count
    --------------------|--------------------
			1			|			94
			2			|		   119
			3			|		   283
			4			|		   479
			5			|		   985
			6			|	      1975	
			7			|		  2257
			8			|		  1030
			9			|		   429
		   10			|		   346					*/



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
	m.production_company, 
    count(r.movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS production_company_rank
FROM movie m
INNER JOIN ratings r ON m.id=r.movie_id
WHERE r.avg_rating > 8 AND production_company IS NOT NULL
GROUP BY m.production_company;

-- Conclusion: 'Dream Warrior Pictures' OR 'National Theatre Live' has produced the most number of hit movies.



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

SELECT g.genre, 
		count(g.movie_id) AS movie_count
FROM movie m
JOIN genre g ON m.id=g.movie_id
JOIN ratings r ON r.movie_id=g.movie_id
WHERE year=2017 AND country LIKE '%USA%' AND month(date_published)=3 AND total_votes>1000
GROUP BY genre
ORDER BY movie_count DESC;

/* Conclusion: In USA, there are more number of movies in genre ‘Drama’ i.e. 24 has released in 2017
----------------|--------------------
	genre		|		movie_count
----------------|--------------------
	Drama		|			24
	Comedy		|			 9
	Action		|			 8
	Thriller	|			 8
	Sci-Fi		|			 7
	Crime		|			 6
	Horror		|			 6
	Mystery		|			 4
	Romance		|			 4
	Fantasy		|			 3
	Adventure	|			 3
	Family		|			 1			*/




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

SELECT title, 
		avg_rating, 
		genre
FROM movie m
JOIN ratings r ON r.movie_id=m.id
JOIN genre g ON g.movie_id=m.id
WHERE title LIKE 'The%' AND avg_rating>8
GROUP BY title
ORDER BY avg_rating DESC;


/* Conclusion: Result shown in the table below.
----------------------------------------|-----------------------|----------------------
	title								|		avg_rating		|		genre
----------------------------------------|-----------------------|----------------------
The Brighton Miracle					|			9.5			|		Drama
The Colour of Darkness					|			9.1			|		Drama
The Blue Elephant 2						|			8.8			|		Drama
The Irishman							|			8.7			|		Crime
The Mystery of Godliness: The Sequel	|			8.5			|		Drama
The Gambinos							|			8.4			|		Crime
Theeran Adhigaaram Ondru				|			8.3			|		Action
The King and I							|			8.2			|		Drama								*/




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating, 
		count(id) AS movie_count
FROM movie m
JOIN ratings r ON m.id=r.movie_id
WHERE date_published>= '2018-04-01' AND date_published<='2019-04-01' AND median_rating = 8;

/* Conclusion: Result shown in the table below.
------------------------|-----------------------
	median_rating		|		movie_count
------------------------|-----------------------
		8				|			361				*/




-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT SUM(total_votes) OVER(PARTITION BY languages) AS total_votes, 
		languages
FROM movie m
JOIN ratings r On r.movie_id=m.id
WHERE languages LIKE 'german' OR languages LIKE 'italian'
GROUP BY languages 
ORDER BY total_votes DESC;

/* Conclusion: Yes, German movies get more votes than Italian movies.
------------------------|------------------------
	total_votes			|		languages
------------------------|------------------------
		4695			|		German
		1684			|		Italian			*/





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


SELECT SUM(CASE WHEN id is null THEN 1 ELSE 0 END) AS 'id',
		SUM(CASE WHEN name is null THEN 1 ELSE 0 END) AS 'name',
		SUM(CASE WHEN height is null THEN 1 ELSE 0 END) AS 'height',
		SUM(CASE WHEN date_of_birth is null THEN 1 ELSE 0 END) AS 'date_of_birth',
		SUM(CASE WHEN known_for_movies is null THEN 1 ELSE 0 END) AS 'known_for_movies'
 FROM names;

/* Conclusion: Height, Date of birth and Know for movies columns have null values.
------------|-----------|-----------|-------------------|--------------------
	id		|	name	|	height	|	date_of_birth	|	known_for_movies
------------|-----------|-----------|-------------------|--------------------
	0		|	  0		|	17335	|		13431		|		15226	*/







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

WITH top_3_genre
AS (
	SELECT genre, 
			count(m.id) AS movie_count, 
            RANK() OVER(ORDER BY COUNT(m.id) DESC)
    FROM movie m
    JOIN genre g ON g.movie_id=m.id
    JOIN ratings r USING(movie_id)
    WHERE avg_rating>8
    GROUP BY genre
    LIMIT 3 
    )
SELECT n.name,
		COUNT(d.movie_id) AS movie_count
FROM director_mapping d
JOIN genre g USING(movie_id)
JOIN names n ON n.id=d.name_id
JOIN top_3_genre tg USING (genre)
JOIN ratings r USING (movie_id)
WHERE avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC LIMIT 3;

/* Conclusion: The top three directors in the top three genres whose movies have an average rating > 8 are
------------------------|----------------------
	director_name		|		movie_count
------------------------|----------------------
	James Mangold		|			4
	Anthony Russo		|			3
	Soubin Shahir		|			3					*/
    


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

SELECT name AS actor, 
		COUNT(r.movie_id) AS movie_count, 
        median_rating
FROM names n
JOIN role_mapping rm ON n.id=rm.name_id
JOIN ratings r USING (movie_id)
JOIN movie m ON m.id=r.movie_id
WHERE median_rating>=8
GROUP BY actor
order by  movie_count DESC
LIMIT 2;

/* Conclusion: The top two actors whose movies have a median rating >= 8 are 'Mammootty' and 'Mohanlal'
----------------|-------------------|----------------------
	actor		|	movie_count		|	median_rating
----------------|-------------------|----------------------
	Mammootty	|		8			|		10
	Mohanlal	|		5			|		 9			*/




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

SELECT production_company, 
		SUM(total_votes) AS vote_count, 
        RANK() OVER(ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM ratings r
JOIN movie m ON m.id=r.movie_id
GROUP BY production_company
LIMIT 3;

/* Coclusion: The top three production houses based on the number of votes received by their movies are 'Marvel Studios' with votes '2656967' got 1st rank, 'Twentieth Century Fox' with votes '2411163' got 2nd rank,
'Warner Bros.' with votes '2396057' 3rd rank.
----------------------------|-------------------|-----------------------
	production_company		|	vote_count		|	prod_comp_rank
----------------------------|-------------------|-----------------------
	Marvel Studios			|	  2656967		|		  1
	Twentieth Century Fox	|	  2411163		|		  2
	Warner Bros.			|	  2396057		|		  3					*/






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

SELECT name AS actor_name,
		total_votes, 
		COUNT(r.movie_id) AS movie_count, 
        ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating,
		RANK() OVER(ORDER BY avg_rating DESC) AS actor_rank
FROM movie m
JOIN ratings r ON r.movie_id=m.id
JOIN role_mapping rm ON rm.movie_id=m.id
JOIN names n ON n.id=rm.name_id
WHERE country='India' AND category='actor'
GROUP BY name having movie_count >=5
ORDER BY avg_rating DESC
LIMIT 1;

/* Conclusion: 'Vijay Sethupathi' got the 1st rank based on actor average rating i.e. ‘8.42’.
	------------------------|-------------------|---------------------|----------------------|--------------
		actor_name			|	 total_votes	|	 movie_count	  |	 actor_avg_rating 	 |	actor_rank
	------------------------|-------------------|---------------------|----------------------|--------------
	Vijay Sethupathi		|		20364		|			5		  |			8.42		 |		1		*/









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

SELECT name AS actress_name,
		total_votes, 
        COUNT(r.movie_id) AS movie_count, 
        ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
		RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actress_rank
FROM movie m
JOIN ratings r ON r.movie_id=m.id
JOIN role_mapping rm ON rm.movie_id=m.id
JOIN names n ON n.id=rm.name_id
WHERE country='India' AND category='actress' AND languages LIKE '%Hindi%'
GROUP BY name having movie_count >=3
ORDER BY actress_avg_rating DESC
LIMIT 5;

/* Conclusion: Top actress in Hindi movies released in India based on their average ratings is 'Taapsee Pannu'. 
------------------------|-------------------|-------------------|------------------------|----------------
	actress_name		|	total_votes		|	movie_count	    |	 actress_avg_rating  |  actress_rank	
------------------------|-------------------|-------------------|------------------------|----------------
	Taapsee Pannu		|		2269		|		3			|			7.74		 |		 1
	Kriti Sanon			|	   14978		|		3			|			7.05		 |		 2
	Divya Dutta			|		 345		|		3			|			6.88		 |		 3	
	Shraddha Kapoor		|		3349		|		3			|			6.63		 |		 4
	Kriti Kharbanda		|		1280		|		3			|			4.80		 |		 5			*/






/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH class
AS (
	SELECT movie_id, avg_rating, 'Superhit movies' AS	classification
	FROM ratings r
	WHERE avg_rating > 8
	UNION
	SELECT movie_id, avg_rating, 'Hit movies' AS	classification
	FROM ratings r
	WHERE avg_rating between 7 AND 8
	UNION
	SELECT movie_id, avg_rating, 'One-time-watch movies' AS	classification
	FROM ratings r
	WHERE avg_rating between 5 AND 7
	UNION
	SELECT movie_id, avg_rating, 'Flop movies' AS	classification
	FROM ratings r
	WHERE avg_rating <5
    )
SELECT title, 
		genre, 
        avg_rating, 
        classification
FROM movie m
JOIN genre g ON g.movie_id=m.id
JOIN class c ON c.movie_id=m.id
WHERE genre='Thriller'
ORDER BY avg_rating DESC;

/* Conclusion: Top 3 movies in 'Thriller' are shown in the below table.
----------------|---------------|-------------------|-------------------
	  title		|	genre		|	 avg_rating		|	classification
----------------|---------------|-------------------|-------------------
	   Safe		|	Thriller	|		9.5			|	Superhit movies
    Digbhayam	|	Thriller	|		9.2			|	Superhit movies
   Dokyala Shot	|	Thriller	|		9.2			|	Superhit movies			*/


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

SELECT genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie AS m 
JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;

/* Conclusion:  Action movies are more lengthier compare to other genre.
--------------------|-------------------|---------------------------|---------------------------    
		genre		|	avg_duration	|	running_total_duration	|	moving_avg_duration
--------------------|-------------------|---------------------------|---------------------------
		Action		|		112.88		|			112.88			|		112.880000
		Adventure	|		101.87		|			214.75			|		107.375000
		Comedy		|		102.62		|			317.37			|		105.790000
		Crime		|		107.05		|			424.42			|		106.105000
		Drama		|		106.77		|			531.19			|		106.238000
		Family		|		100.97		|			632.16			|		105.360000
		Fantasy		|		105.14		|			737.30			|		105.328571
		Horror		|		 92.72		|			830.02			|		103.752500
		Mystery		|		101.80		|			931.82			|		103.535556
		Others		|		100.16		|		   1031.98			|		103.198000
		Romance		|		109.53		|		   1141.51			|		103.773636
		Sci-Fi		|		 97.94		|		   1239.45			|		102.415455
		Thriller	|		101.58		|		   1341.03			|		102.389091			*/




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genres 
AS (
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 
	), 
movie_summary 
AS(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      worlwide_gross_income,
                      DENSE_RANK() OVER(partition BY year ORDER BY worlwide_gross_income DESC ) AS movie_rank
           FROM       movie                                                                     AS m
           INNER JOIN genre                                                                     AS g
           ON         m.id = g.movie_id
           WHERE      genre IN(SELECT genre FROM top_genres)
		   GROUP BY   movie_name
  )
SELECT *
FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR, genre;

/* Conclusion: Highest-grossing movies of each year that belong to the top three genres are mentioned below
------------------------------------------------------------------------------------------------------------
	In 2017,     Drama,     Shatamanam Bhavati
	In 2018,     Action,     The Villain
	In 2019,     Action,     Code Geass: Fukkatsu No Lelouch		*/



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

SELECT production_company, 
		COUNT(id) AS movie_count, 
        RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m
JOIN ratings r ON r.movie_id=m.id
WHERE languages LIKE '%,%' AND median_rating >= 8 AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY movie_count DESC
LIMIT 2;

/* Conclusion: Top two production houses that have produced the highest number of hits among multilingual movies are as follows: 'Star Cinema' and 'Twentieth Century Fox'.
	------------------------|-------------------|-----------------------
    production_company 		|	movie_count		|	prod_comp_rank
	------------------------|-------------------|-----------------------
	Star Cinema		   		| 		7			|		1
	Twentieth Century Fox	|		4			|		2			*/







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

SELECT name AS actress_name,
			   SUM(total_votes) AS total_votes,
			   COUNT(movie_id) AS movie_count, ROUND(sum(avg_rating*total_votes)/sum(total_votes),2) AS actress_avg_rating,
			   RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS actress_rank
FROM movie m
JOIN genre g ON g.movie_id=m.id
JOIN ratings r USING(movie_id)
JOIN role_mapping rm USING(movie_id)
JOIN names n ON n.id=rm.name_id
WHERE avg_rating>8 AND genre='Drama' AND category='actress'
GROUP BY actress_name
ORDER BY movie_count DESC
LIMIT 3;

/*  Conclusion: Top 3 actresses based on number of Super Hit movies in drama genre are 1)Parvathy Thiruvothu 2)Susan Brown 3)Amanda Lawrence
	--------------------|-------------------|-----------------|----------------------|-----------------
	actress_name		|	total_votes		|	movie_count	  |	actress_avg_rating	 |	actress_rank
    --------------------|-------------------|-----------------|----------------------|-----------------
	Parvathy Thiruvothu	|		4974		|		2		  |			8.25		 |		1
	Susan Brown			|		 656		|		2		  |			8.94		 |		1
	Amanda Lawrence		|		 656		|		2		  |			8.94		 |	    1			*/


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id -
Name		-
Number of movies	-
Average inter movie duration in days
Average movie ratings	-
Total votes	-
Min rating-	
Max rating-	
total movie durations	-

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

WITH movie_date_info 
AS(
	SELECT d.name_id, name, d.movie_id,
		   m.date_published, 
		   LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
	FROM director_mapping d
	JOIN names AS n 
	ON d.name_id=n.id 
	JOIN movie AS m 
	ON d.movie_id=m.id
  ),
  
date_difference 
AS(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
avg_inter_days 
AS(
	 SELECT name_id, 
			AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
director
AS(
	SELECT name_id AS director_id, title, 
		   name AS director_name, 
		   COUNT(movie_id) AS number_of_movies, 
		   RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS director_rank
	FROM movie m
	JOIN director_mapping dm ON dm.movie_id=m.id
	JOIN names n ON n.id=dm.name_id
	JOIN ratings USING (movie_id)
	GROUP BY director_id
	ORDER BY number_of_movies DESC
	LIMIT 9
  )
SELECT   director_id, 
		 director_name, 
		 number_of_movies, 
         ROUND(avg_inter_movie_days) AS avg_inter_movie_days,
		 ROUND(AVG(avg_rating),2)  AS Average_movie_ratings,
         ROUND(SUM(total_votes),2)  AS total_votes,
         min(avg_rating) AS min_rating,
         max(avg_rating) AS max_rating,
         SUM(duration) AS total_movie_durations
FROM movie m
JOIN ratings r ON r.movie_id=m.id
JOIN director_mapping dm ON dm.movie_id=m.id
JOIN director d ON d.director_id=dm.name_id
JOIN movie_date_info USING(name_id)
JOIN avg_inter_days a USING(name_id)
GROUP BY director_name
ORDER BY number_of_movies DESC
LIMIT 9;


/* Conclusion: Top 2 directors (based on number of movies) 1)Andrew Jones with 5 movies 2)A.L Vijay with 5 movies 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration 
------------|-------------------|---------------------|----------------------|--------------|--------------|------------|------------|-----------------
nm2096009	|	Andrew Jones	|			5		  |			191			 |		3.02	|	  9945	   |      2.7	|     3.2	 |   2160
nm1777967	|	A.L. Vijay		|			5		  | 		177			 |		5.42	|	  8770	   |      3.7	|     6.9	 |   3065
nm6356309	|	Özgür Bakar		|			4		  |         112			 | 		3.75	|	  4368	   |      3.1	|     4.9	 |   1496
nm2691863	|	Justin Price	|           4	      |         315     	 |      4.50	|    21372	   |      3.0	|     5.8	 |   1384
nm0814469	|   Sion Sono	    |           4	      |         331			 |		6.03	|	 11888	   |      5.4	|     6.4	 |   2008
nm0831321	|   Chris Stokes	|   		4		  |			198			 |		4.33	|	 14656	   |	  4.0	|	  4.6	 |   1408
nm0425364	|  Jesse V. Johnson |			4		  |			299			 |		5.45	|	 59112	   |	  4.2	|	  6.5	 |	 1532
nm0001752	|  Steven Soderbergh|			4		  |			254			 |		6.48	|	686736	   | 	  6.2	|	  7.0	 |   1604
nm0515005	|	Sam Liu			|			4		  |			260			 |		6.23	|	114228	   |	  5.8	|	  6.7	 |   1248

*/