-- focus area 3: director & cast influence and focus area 4: Language & Market Reach Analysis

--  step 1 — create tables (normalized)

create database if not exists movies_sqldb;
use movies_sqldb;

-- table: movies
create table movies (
    movie_id int primary key,
    original_language varchar(50),
    popularity float,
    release_date date,
    runtime int,
    status varchar(50),
    vote_average float,
    vote_count int,
    budget bigint,
    revenue bigint,
    profit bigint,
    director_id int
);

create table directors (
    director_id int primary key,
    director_name varchar(255)
);

create table genres (
    genre_id int primary key,
    genre_name varchar(255)
);

create table production_companies (
    company_id int primary key,
    company_name varchar(255)
);

create table actors (
    actor_id int primary key,
    actor_name varchar(255)
);

create table movie_genres (
    movie_id int,
    genre_id int
);

create table movie_actors (
    movie_id int,
    actor_id int
);

create table movie_companies (
    movie_id int,
    company_id int
);


--  step 2: import the csv files into mysql

-- ================================
-- 1. movies.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/movies.csv'
into table movies
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(movie_id, original_language, popularity, release_date, runtime, status, vote_average, vote_count, budget, revenue, profit, director_id);

-- ================================
-- 2. production_companies.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/production_companies.csv'
into table production_companies
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(company_name, company_id);

-- ================================
-- 3. actors.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/actors.csv'
into table actors
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(actor_name, actor_id);

-- ================================
-- 4. directors.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/directors.csv'
into table directors
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(director_name, director_id);

-- ================================
-- 5. genres.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/genres.csv'
into table genres
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(genre_name, genre_id);

-- ================================
-- 6. movie_actors.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/movie_actors.csv'
into table movie_actors
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(movie_id, actor_id);

-- ================================
-- 7. movie_companies.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/movie_companies.csv'
into table movie_companies
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(movie_id, company_id);

-- ================================
-- 8. movie_genres.csv
load data infile 'c:/programdata/mysql/mysql server 8.0/uploads/movie_genres.csv'
into table movie_genres
fields terminated by ',' enclosed by '"' 
lines terminated by '\n'
ignore 1 rows
(movie_id, genre_id);


-- step 3: establish foreign keys

-- 1. movies (linking to directors)
alter table movies
add constraint fk_movies_director
    foreign key (director_id)
    references directors(director_id);

-- 2. movie_actors (foreign keys only, primary key assumed to exist)
alter table movie_actors
add constraint fk_movieactors_movie
    foreign key (movie_id)
    references movies(movie_id),
add constraint fk_movieactors_actor
    foreign key (actor_id)
    references actors(actor_id);


-- 3. movie_companies (foreign keys only)
alter table movie_companies
add constraint fk_moviecompanies_movie
    foreign key (movie_id)
    references movies(movie_id),
add constraint fk_moviecompanies_company
    foreign key (company_id)
    references production_companies(company_id);

-- 4. movie_genres (foreign keys only)
alter table movie_genres
add constraint fk_moviegenres_movie
    foreign key (movie_id)
    references movies(movie_id),
add constraint fk_moviegenres_genre
    foreign key (genre_id)
    references genres(genre_id);


-- ======================================================================================================================================================================================
-- Focus Area 3: Director & Cast Influence


-- query 1: top 5 directors with the highest total revenue

select d.director_name, sum(m.revenue) as total_revenue
from movies m
join directors d on m.director_id = d.director_id
group by d.director_name
order by total_revenue desc
limit 5;


-- query 2: top 5 actors who appeared in the most movies

select a.actor_name, count(ma.movie_id) as movie_count
from actors a
join movie_actors ma on a.actor_id = ma.actor_id
group by a.actor_name
order by movie_count desc
limit 5;


-- query 3: top 5 directors based on average profit per movie

select d.director_name, avg(m.profit) as avg_profit
from movies m
join directors d on m.director_id = d.director_id
group by d.director_name
order by avg_profit desc
limit 5;

-- query 4: which actors have worked under the highest number of different directors?

select a.actor_name, count(distinct m.director_id) as unique_directors
from actors a
join movie_actors ma on a.actor_id = ma.actor_id
join movies m on ma.movie_id = m.movie_id
group by a.actor_name
order by unique_directors desc
limit 5;

-- query 5: find the most profitable movie along with its director and top-billed actor (first actor in the dataset for that movie)

select m.movie_id, m.profit, d.director_name, a.actor_name as lead_actor
from movies m
join directors d on m.director_id = d.director_id
join movie_actors ma on m.movie_id = ma.movie_id
join actors a on ma.actor_id = a.actor_id
where m.profit = (select max(profit) from movies)
limit 1;


-- query 6: top 10 most frequent actors with revenue

select 
    a.actor_name as actor, 
    count(ma.movie_id) as movie_count, 
    sum(m.revenue) as total_revenue
from actors a
join movie_actors ma on a.actor_id = ma.actor_id
join movies m on ma.movie_id = m.movie_id
group by a.actor_name
order by movie_count desc
limit 10;

-- query 7: average revenue of movies with top actors vs others

select 
    case 
        when lower(a.actor_name) in ('Vincent D''Onofrio', 'robert de niro', 'samuel l. jackson', 'bruce willis', 'matt damon', 'morgan freeman', 'nicolas cage', 'johnny depp', 'brad pitt', 'owen wilson') then 'a-list'
        else 'others'
    end as actor_type,
    count(m.movie_id) as num_movies,
    avg(m.revenue) as avg_revenue,
    avg(m.vote_average) as avg_rating
from actors a
join movie_actors ma on a.actor_id = ma.actor_id
join movies m on ma.movie_id = m.movie_id
group by actor_type;

-- query 8: compare performance of first-time vs experienced directors

 select 
    case 
        when dm.num_movies = 1 then 'first-time'
        else 'experienced'
    end as director_type,
    count(m.movie_id) as total_movies,
    avg(m.revenue) as avg_revenue,
    avg(m.vote_average) as avg_rating
from movies m
join (
    select 
        director_id, 
        count(movie_id) as num_movies
    from movies
    group by director_id
) dm on m.director_id = dm.director_id
group by director_type;


-- query 9: director-wise success over time (yearly)

select 
    d.director_name as director, 
    year(m.release_date) as release_year,
    count(m.movie_id) as num_movies, 
    sum(m.revenue) as total_revenue
from directors d
join movies m on d.director_id = m.director_id
group by d.director_name, release_year
order by total_revenue desc
limit 5;

-- query 11: top 5 directors overall
select 
    d.director_name as director,
    count(m.movie_id) as num_movies, 
    sum(m.revenue) as total_revenue
from directors d
join movies m on d.director_id = m.director_id
group by d.director_name
order by total_revenue desc
limit 5;


-- totals
select 
    (select count(*) from directors) as total_directors,
    (select count(*) from actors) as total_actors,
    sum(m.revenue) as total_box_office,
    avg(m.vote_average) as average_rating
from movies m;


-- ---------------------------------------------------------------------------------------

/* Interpretations of  Focus Area 3: Director & Cast Influence:

Identify directors who consistently drive high revenue
	Steven Spielberg leads with $5.3B across 27 films — more than double any other director.
Evaluate directors based on average profit per film
	Joseph Kosinski delivers the highest profit per movie, averaging $139.6M.
Assess actors with the highest reach and impact
	Vincent D’Onofrio tops with 223 movies, $8.66B revenue, working with 190 unique directors.
Evaluate A-list actors’ influence on success
	A-list actors earn avg. $80.6M per movie and score 6.03 ratings.
Analyze how directorial experience affects outcomes
	Experienced directors like Steven Spielberg bring 3.5× more revenue and higher ratings (6.27 vs 5.69). */



-- --------------------------------------------------------------------------------------


use movies_sqldb;

-- -- Focus Area 4:  language & market reach analysis

-- 1. top 5 languages by average revenue
select original_language, 
       count(*) as movie_count, 
       avg(revenue) as avg_revenue, 
       avg(popularity) as avg_popularity
from movies
group by original_language
order by avg_revenue desc
limit 5;

-- 2. compare non-english vs. english movie performance
select 
    case when original_language = 'en' then 'english' else 'non-english' end as language_category,
    count(*) as movie_count,
    avg(revenue) as avg_revenue,
    avg(popularity) as avg_popularity
from movies
group by language_category;

-- 3. identify top 5 high-performing non-english movies
select original_language, movie_id, revenue, popularity
from movies
where original_language <> 'en'
order by revenue desc
limit 5;


-- 4. top 5 genres in non-english markets
select g.genre_name, count(*) as movie_count, avg(m.revenue) as avg_revenue
from movies m
join movie_genres mg on m.movie_id = mg.movie_id
join genres g on mg.genre_id = g.genre_id
where m.original_language <> 'en'
group by g.genre_name
order by avg_revenue desc
limit 5;

/* Interpretations of  Focus Area 4:  language & market reach analysis

Identify languages driving the highest movie revenue
	Japanese and English films stand out for top average earnings.
Compare English vs. Non-English movie performance
	English films earn 3× more, though Japanese and Chinese lead among non-English titles.
Evaluate genre trends in non-English markets
	Fantasy and Adventure genres bring in the most revenue abroad.

*/


