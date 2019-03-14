--Schema


--Movie ( mID, title, year, director ) 
--English: There is a movie with ID number mID, a title, a release year, and a director. 

--Reviewer ( rID, name ) 
--English: The reviewer with ID number rID has a certain name. 

--Rating ( rID, mID, stars, ratingDate ) 
--English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate. 


--Find the titles of all movies directed by Steven Spielberg. 

--Q1 Find the titles of all movies directed by Steven Spielberg. 

Select title 
from Movie 
where director = "Steven Spielberg";

--Q2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

select distinct m1.year from Rating r1, Movie m1
where (r1.stars = 4 or r1.stars = 5)
and m1.mID = r1.mID
order by m1.year;

--Q3 Find the titles of all movies that have no ratings. 

Select 
m1.title
from Movie m1
where m1.mID not in (select mID from Rating) ; 


--Q4 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

Select 
rev1.name
from Reviewer rev1, Rating r1
where rev1.rID = r1.rID
and coalesce(r1.ratingDate,0) = 0;


--Q5 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

select rev1.name, m1.title, r1.stars, r1.ratingDate
from Reviewer rev1, Movie m1, Rating r1
where 
rev1.rID = r1.rID
and r1.mID = m1.mID
order by 
rev1.name, m1.title, r1.stars;


--Q6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 

select  rev1.name,m1.title from Rating r1, Rating r2, Movie m1, Reviewer rev1
where r1.rid = r2.rid
and coalesce(r1.ratingDate,0) > coalesce(r2.ratingDate,0)
and r1.mId = r2.mid
and r1.stars > r2.stars
and rev1.rID = r1.rID
and m1.mID = r1.mID;

--Q7 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

select m1.title, r1.Stars
from Rating r1, Movie m1
where 1 > (select count(distinct r2.stars) 
          from Rating r2 
          where r1.stars < r2.stars
          and r1.mID = r2.mID
          )
and m1.mID = r1.mID
group by m1.title;


--Q8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

select m.title, (coalesce(max(r.stars),0) - coalesce(min(r.stars),0)) as diff
from Movie m,Rating r
where m.mID = r.mID
group by
m.title 
order by diff desc;


--Q9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages --for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

select avg(before1980.avg1) - avg(after1980.avg1)
from
(select avg(r.stars) as avg1,r.mID
from Movie m, Rating r
where m.mID = r.mID
and m.year > 1980
group by r.mID) as after1980,
(select avg(r.stars) as avg1,r.mID
from Movie m, Rating r
where m.mID = r.mID
and m.year < 1980
group by r.mID) as before1980;



















