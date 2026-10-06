create database restaurant_db;
use restaurant_db;

#Parent table
create table consumers(Consumer_ID varchar(10) primary key,City varchar(225),State varchar(225),
Country varchar(225),
Latitude decimal(10,7),Longitude decimal(10,7),Smoker varchar(10),Drink_Level varchar(50),
Transportation_Method varchar(50),Marital_Status varchar(20),Children varchar(20),Age int,
Occupation varchar(50),Budget varchar(10));

-- insert into consumers(Consumer_ID,City,State,Country,Latitude,Longitude,Smoker,Drink_Level,Transportation_Method,Marital_Status,Children,Age,Occupation,Budget)
-- values(

#Child table
create table consumer_preferences(Consumer_ID varchar(10),Preferred_Cuisine varchar(255),
foreign key(Consumer_ID) references consumers(Consumer_ID));


select * from consumers;

select count(*) from consumers;


create table restaurants(Restaurant_ID varchar(10) primary key,Name varchar(255) ,
City varchar(225),State varchar(225),
Country varchar(225),Zip_Code varchar(255),
Latitude decimal(10,8),Longitude decimal(11,8),Alcohol_Service varchar(50),
Smoking_Allowed varchar(50),
Price varchar(10),Franchise varchar(5),Area varchar(10),Parking varchar(50));

select * from consumer_preferences;

select * from restaurants;

select count(*) from restaurants;

create table restaurant_cuisines(Restaurant_ID varchar(10),Cuisine varchar(255),
foreign key(Restaurant_ID) references restaurants(Restaurant_ID));


select * from restaurant_cuisines;

select count(*) from restaurant_cuisines;



create table ratings(Consumer_ID varchar(10),Restaurant_ID varchar(10),Overall_Rating int,
Food_Rating int,Service_Rating int,
foreign key(Consumer_ID) references consumers(Consumer_ID),
foreign key(Restaurant_ID) references restaurants(Restaurant_ID));

-- Objective: 

-- Using the WHERE clause to filter data based on specific criteria.

-- 1.	List all details of consumers who live in the city of 'Cuernavaca'.
select * 
from consumers 
where City = 'Cuernavaca';
 #22


-- 






-- 2.	Find the Consumer_ID, Age, and Occupation of all
--  consumers who are 'Students' AND are 'Smokers'.
select Consumer_ID, Age, Occupation 
from consumers 
where Occupation ='Student'
and Smoker ='Yes'; #23

-- 3.	List the Name, City, Alcohol_Service, and 
-- Price of all restaurants that serve 'Wine & Beer' 
-- and have a 'Medium' price level.
select  Name, City, Alcohol_Service, Price 
from restaurants 
where price ='Medium' 
and Alcohol_Service ='Wine & Beer';

-- 4.	Find the names and cities of all 
-- restaurants that are part of a 'Franchise'.
select name,city 
from restaurants 
where Franchise ='Yes';

-- 5.	Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings
--  where the Overall_Rating was 'Highly Satisfactory' 
-- (which corresponds to a value of 2, according to the data dictionary).
--  486
select  Consumer_ID, Restaurant_ID,  Overall_Rating
from ratings 
where Overall_Rating =2;




select * from consumers;
select * from consumer_preferences;-- Questions JOINs with Subqueries

-- 1.	List the names and cities of all restaurants that have an
--  Overall_Rating of 2 (Highly Satisfactory) from at least one consumer.
select name as Restaurant_name,City from restaurants re
join ratings r on re.Restaurant_ID = r.Restaurant_ID
where Overall_Rating = 2;

-- 2.	Find the Consumer_ID and Age of consumers who have rated restaurants located in 'San Luis Potosi'.  
-- (Here,joined 3 tables by thier common coloum

#consumers(Consumer_ID) --> ratings(Consumer_ID) --> ratings(restaurant_ID) ----> restuarant(restaurant_ID)
select c.Consumer_ID,c.age,re.City as restaurant_city  from consumers c
join ratings r on c.Consumer_ID = r.Consumer_ID 
left join restaurants re on r.Restaurant_ID = re.Restaurant_ID 
where re.City = 'San Luis Potosi';


#Is this coorect
-- 3.	List the names of restaurants that serve 'Mexican' cuisine and have been rated by consumer 'U1001'.
select re.Name ,cu.Cuisine,c.Consumer_ID,r.Overall_Rating from restaurants re
join restaurant_cuisines cu on re.Restaurant_ID = cu.Restaurant_ID
left join ratings r on r.Restaurant_ID = re.Restaurant_ID
left join consumers c on c.Consumer_ID=r.Consumer_ID
where cu.Cuisine = 'Mexican' and c.Consumer_ID = 'U1001';

-- 4.	Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
select * from consumers c
left join consumer_preferences cp on c.Consumer_ID = cp.Consumer_ID
where cp.Preferred_Cuisine = 'American' and Budget='Medium';


-- ***************
-- 5.	List restaurants (Name, City) that have received a Food_Rating lower than the
--  average Food_Rating across all rated restaurants.
select re.Name as restaurant_name,re.City from restaurants re
join ratings r on re.Restaurant_ID = r.Restaurant_ID
where r.Food_Rating < (select avg(Food_rating) from ratings);

#### HEre we can see the resturants which are below avg. rated

#consumer -> rating -> restaurant_cusines

-- c.Consumer_ID, Age, Occupation,rc.cuisine


 -- *************
###IS this correct.
-- 6.	Find consumers (Consumer_ID, Age, Occupation) who have 
-- rated at least one restaurant but have NOT 
-- rated any restaurant that serves 'Italian' cuisine.
SELECT DISTINCT c.Consumer_ID, c.Age, c.Occupation
FROM consumers c
JOIN ratings r
    ON c.Consumer_ID = r.Consumer_ID
WHERE NOT EXISTS (
    SELECT 1
    FROM ratings r2
    JOIN restaurant_cuisines rc
        ON r2.Restaurant_ID = rc.Restaurant_ID
    WHERE r2.Consumer_ID = c.Consumer_ID
      AND rc.Cuisine = 'Italian'
); 



  #here excluding Italian


-- 7.	List restaurants (Name) that have received ratings from consumers older than 30.
select * from restaurants re 
join ratings r using(Restaurant_Id)
join consumers c using(Consumer_ID)
where age > 30
order by age;


#Ask
#here at least one mean one or more right ,so applying distinct is it correct.
-- 8.	Find the Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and who have given an Overall_Rating of 0 to at least one restaurant (any restaurant).
select  distinct Consumer_ID , Occupation  from consumers c
join consumer_preferences using(Consumer_ID)
join ratings r using(Consumer_ID)
where Preferred_cuisine = 'Mexican' 
and r.overall_rating =0;


#Ask is,this correct
-- 9.	List the names and cities of restaurants that serve 'Pizzeria' cuisine and are located in a city where at least one 'Student' consumer lives.
select re.name,re.city,  c.Occupation from restaurants re
join restaurant_cuisines rc using(Restaurant_ID)
join ratings r using(Restaurant_ID)
join consumers c using(Consumer_ID)
where rc.Cuisine = 'Pizzeria'
and re.city  in (select distinct c.city from consumers c where c.occupation ='Student');


-- 10.	Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
select * from consumers c
join ratings r using(Consumer_ID)
join restaurants re using(Restaurant_ID)
where Drink_Level= 'Social Drinkers' and re.parking ='None';

#Oberserved that their no Social drinker restaurant consumers who have rated restaurant whcin have no parking.



-- Questions Emphasizing WHERE Clause and Order of Execution

-- 1.	List Consumer_IDs and the count of restaurants they've rated, 
-- but only for consumers who are 'Students'. 
-- Show only students who have rated more than 2 restaurants.
select distinct c.consumer_ID,count(*) as restaurant_Count  
from consumers c
 join ratings r on c.Consumer_ID = r.Consumer_ID 
 where c.Occupation='student'
group by c.Consumer_ID
having count(*) > 2; 



-- Highly engaged student consumers may be useful targets for personalized promotions or recommendation strategies.

-- So this remains a possible final-PPT query.


-- 2.	We want to categorize consumers by an 'Engagement_Score' 
-- which is their Age divided by 10 (integer division).
--  List the Consumer_ID, Age, and this calculated Engagement_Score, but only for 
-- consumers whose Engagement_Score would be exactly 2 and who use 'Public' transportation.
select Consumer_ID, Age,age div 10 as Engagement_Score ,budget
from consumers 
where age div 10 = 2 and 
Transportation_Method ='public';




#here we cant use Engagement_Score in where cluase bcz,where is executed before select 

-- Insight:  
-- Identified a young consumer segment aged 20–29 who use public transportation, 
-- providing an opportunity to understand and personalize their restaurant experience.

-- Recommendation:  
-- Analyze their cuisine preferences, budgets, ratings, and restaurant locations to 
-- provide more relevant restaurant recommendations and targeted offers


#3.********** include this in ppt.







-- 3.	For each restaurant, calculate its average Overall_Rating. 
-- Then, list the restaurant Name, City,and its calculated average Overall_Rating, 
-- but only for restaurants located in 'Cuernavaca' AND 
-- whose calculated average Overall_Rating is greater than 1.0.
select re.Name, re.City,
avg(r.Overall_rating) as average_Overall_Rating 
 from restaurants re 
join ratings r using(Restaurant_ID)
where re.city = 'Cuernavaca'  
group by restaurant_ID,
re.Name,re.City
having average_Overall_Rating >1;





-- ,> 1 means with highly satisfaied rated restaurent

#include in ppt
-- 4.	Find consumers (Consumer_ID, Age) who are 'Married' and
--  whose Food_Rating for any restaurant is equal to their Service_Rating for 
--  that same restaurant, but only consider ratings where the Overall_Rating was 2.
select c.Consumer_ID, Age from consumers c
join ratings rt on c.Consumer_ID = rt.Consumer_ID
where Marital_Status ='Married' and rt.Overall_Rating =2
and rt.Food_Rating=rt.Service_Rating;

-- You could say something like:
-- "The query identifies married consumers who
--  gave the highest Overall_Rating in cases where their Food_Rating and Service_Rating were equal."




#4.##########33
-- 5.	List Consumer_ID, Age, and the Name of any restaurant they rated, but only for consumers who are 
-- 'Employed' and have given a Food_Rating of 0 to at least one restaurant located in 'Ciudad Victoria'.
select c.Consumer_ID, Age, Name as restaurant_name from consumers c
join ratings rt on c.Consumer_ID = rt.Consumer_ID
join restaurants r on rt.Restaurant_ID=r.Restaurant_ID
where occupation ='Employed' and rt.Food_rating =0 and r.city ='Ciudad Victoria';
-- 


#Costomer democrafy who are employeed and given a unstisfied food_rating to restaurant located in Ciudad Victoria


-- Advanced SQL Concepts: Derived Tables, CTEs, Window Functions, Views, Stored Procedures

-- 1.	Using a CTE, find all consumers who live in 'San Luis Potosi'.
--  Then, list their Consumer_ID, Age, and the Name of any Mexican restaurant
--  they have rated with an Overall_Rating of 2.
WITH SanLuisPotosiConsumers AS (
    SELECT Consumer_ID,
           Age
    FROM consumers
    WHERE City = 'San Luis Potosi'
)
SELECT DISTINCT 
       slp.Consumer_ID,
       slp.Age,
       r.Name AS Restaurant_Name
FROM SanLuisPotosiConsumers slp
JOIN ratings ra
    ON slp.Consumer_ID = ra.Consumer_ID
JOIN restaurants r
    ON ra.Restaurant_ID = r.Restaurant_ID
JOIN restaurant_cuisines rc
    ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
  AND ra.Overall_Rating = 2;
  

#5###########
-- 2.	For each Occupation, find the average age of consumers.
--  Only consider consumers who have made at least one rating. 
-- (Use a derived table to get consumers who have rated).
select occupation,avg(age) from consumers
join (select distinct Consumer_ID from ratings rt) r using(Consumer_ID)
group by occupation;




-- 3.	Using a CTE to get all ratings for restaurants in 'Cuernavaca', rank these ratings 
-- within each restaurant based on Overall_Rating (highest first). 
-- Display Restaurant_ID, Consumer_ID, Overall_Rating, and the RatingRank.
WITH CuernavacaRatings AS (
    SELECT 
        r.Restaurant_ID,
        rt.Consumer_ID,
        rt.Overall_Rating
    FROM restaurants r
    JOIN ratings rt
        ON r.Restaurant_ID = rt.Restaurant_ID
    WHERE r.City = 'Cuernavaca'
)
SELECT 
    Restaurant_ID,
    Consumer_ID,
    Overall_Rating,
    RANK() OVER (
        PARTITION BY Restaurant_ID
        ORDER BY Overall_Rating DESC
    ) AS RatingRank
FROM CuernavacaRatings
ORDER BY Restaurant_ID, RatingRank, Consumer_ID;


#For 132560 restuarant ,customer Id ui087,ui1067 as given same overall rating as satisfaied , as given good rating, so they are ranked First.


-- 4.	For each rating, show the Consumer_ID, Restaurant_ID, Overall_Rating, 
-- and also display the average Overall_Rating given by that specific consumer across all their ratings.
select Consumer_ID, Restaurant_ID, Overall_Rating,avg(Overall_Rating) from ratings 
group by Consumer_ID, Restaurant_ID, Overall_Rating;


#here we can observe ,diff Cusomer u1077 atends each consumer attends diff. restuarrant and given rating , and here calcualted avg overall rating.


#6########

-- 5.	Using a CTE, identify students who have a 'Low' budget.
--  Then, for each of these students, 
-- list their top 3 most preferred cuisines based on 
-- the order they appear in the Consumer_Preferences 
-- table (assuming no explicit preference order, 
-- use Consumer_ID, Preferred_Cuisine to define order for ROW_NUMBER).

WITH LowBudgetStudents AS (
    SELECT Consumer_ID,Age,Occupation,Budget
    FROM consumers
    WHERE Occupation = 'Student'
      AND Budget = 'Low'
),
RankedPreferences AS (
    SELECT lbs.Consumer_ID,cp.Preferred_Cuisine,
        ROW_NUMBER() OVER (
            PARTITION BY lbs.Consumer_ID
            ORDER BY lbs.Consumer_ID, cp.Preferred_Cuisine
        ) AS PreferenceRank
    FROM LowBudgetStudents lbs
    JOIN consumer_preferences cp
        ON lbs.Consumer_ID = cp.Consumer_ID
)
SELECT 
    Consumer_ID,Preferred_Cuisine,PreferenceRank
FROM RankedPreferences
WHERE PreferenceRank <= 3
ORDER BY Consumer_ID, PreferenceRank;



#Here 2 ctes are created ,secind cte is using cte from first one.
-- "First, I used a CTE to filter consumers with a Low budget. 
-- Then I joined them with the Consumer_Preferences table and used ROW_NUMBER() to rank their preferred cuisines. 
-- Finally, I selected the first three cuisines for each consumer."




-- 6.	Consider all ratings made by 'Consumer_ID' = 'U1008'. For each rating, show the Restaurant_ID, Overall_Rating, and the Overall_Rating of the next restaurant they rated (if any), 
-- ordered by Restaurant_ID (as a proxy for time if rating time isn't available). Use a derived table to filter for the consumer's ratings first.

select Restaurant_ID,Overall_Rating,
Lead(Overall_Rating) over(order by Restaurant_ID) as Next_Rating
from (
select * from ratings where Consumer_ID ='U1008') as Consumer_Ratings
order by Restaurant_ID;

#7#######33
-- 7.	Create a VIEW named HighlyRatedMexicanRestaurants that shows 
-- the Restaurant_ID, Name, and City of all Mexican restaurants 
-- that have an average Overall_Rating greater than 1.5.

create view HighlyRatedMexicanRestaurants as
select Restaurant_ID, Name,  City,avg(Overall_Rating) as avgRating from restaurants 
join restaurant_cuisines using(Restaurant_ID)
join ratings using(Restaurant_ID)
where Cuisine ='Mexican' 
group by Restaurant_ID, Name,  City
having avgRating > 1.5;

select * from HighlyRatedMexicanRestaurants;


#8#######
-- 8.	First, ensure the HighlyRatedMexicanRestaurants view from Q7 exists. 
-- Then, using a CTE to find consumers who prefer 'Mexican' cuisine, 
-- list those consumers (Consumer_ID)
--  who have not rated any restaurant listed in 
-- the HighlyRatedMexicanRestaurants view.
with mexicanConsumers As (
select consumer_ID from Consumer_Preferences
where Preferred_Cuisine ='Mexican')
select mc.Consumer_ID from mexicanConsumers mc
WHERE NOT EXISTS (
    SELECT 1
    FROM Ratings r
    JOIN HighlyRatedMexicanRestaurants h
        ON r.Restaurant_ID = h.Restaurant_ID
    WHERE r.Consumer_ID = mc.Consumer_ID);
-- 9.	Create a stored procedure GetRestaurantRatingsAboveThreshold that 
-- accepts a Restaurant_ID and a minimum Overall_Rating as input. 
-- It should return the Consumer_ID,
--  Overall_Rating, Food_Rating, and Service_Rating for that restaurant 
-- where the Overall_Rating meets or exceeds the threshold.
delimiter $$
create procedure GetRestaurantRatingsAboveThreshold(in p_Restaurant_ID varchar(20) 
,in p_min_ovarallRating int)
begin
select Consumer_ID,Overall_Rating, Food_Rating, Service_Rating 
from ratings rt
where rt.Restaurant_ID = p_Restaurant_ID and overall_Rating >=p_min_ovarallRating;
end $$
delimiter   ;
call GetRestaurantRatingsAboveThreshold(132732,0);



-- 9.##########
-- 10.	Identify the top 2 highest-rated (by Overall_Rating) restaurants for each cuisine type. 
-- If there are ties in rating, include all tied restaurants. 
-- Display Cuisine, Restaurant_Name, City, and Overall_Rating.
WITH RestaurantRatings AS (
    SELECT
        rc.Cuisine,
        r.Restaurant_ID,
        r.Name AS Restaurant_Name,
        r.City,
        AVG(rt.Overall_Rating) AS Overall_Rating
    FROM Restaurants r
    JOIN Restaurant_Cuisines rc
        ON r.Restaurant_ID = rc.Restaurant_ID
    JOIN Ratings rt
        ON r.Restaurant_ID = rt.Restaurant_ID
    GROUP BY
        rc.Cuisine,
        r.Restaurant_ID,
        r.Name,
        r.City
),
RankedRestaurants AS (
    SELECT
        Cuisine,
        Restaurant_Name,
        City,
        Overall_Rating,
        DENSE_RANK() OVER (
            PARTITION BY Cuisine
            ORDER BY Overall_Rating DESC
        ) AS rating_rank
    FROM RestaurantRatings
)
SELECT
    Cuisine,
    Restaurant_Name,
    City,
    Overall_Rating
FROM RankedRestaurants
WHERE rating_rank <= 2
ORDER BY Cuisine, rating_rank;





-- 11.	First, create a VIEW named ConsumerAverageRatings that lists Consumer_ID and their average Overall_Rating. Then, using this view and a CTE, find the top 5 consumers by 
-- their average overall rating. For these top 5 consumers, list their Consumer_ID, 
-- their average rating, and the number of 'Mexican' restaurants they have rated.


create view ConsumerAverageRatings
as select Consumer_ID,avg(overall_rating) as avg_rating from  ratings 
group by Consumer_ID;

WITH Top5Consumers AS (
    SELECT
        Consumer_ID,
        avg_rating
    FROM ConsumerAverageRatings
    ORDER BY avg_rating DESC
    LIMIT 5
)
SELECT
    t.Consumer_ID,
    t.avg_rating,
    COUNT(DISTINCT r.Restaurant_ID) AS Mexican_Restaurants_Rated
FROM Top5Consumers t
JOIN Ratings r
    ON t.Consumer_ID = r.Consumer_ID
JOIN Restaurant_Cuisines rc
    ON r.Restaurant_ID = rc.Restaurant_ID
WHERE rc.Cuisine = 'Mexican'
GROUP BY
    t.Consumer_ID,
    t.avg_rating
ORDER BY t.avg_rating DESC;

#10.############
-- 12.	Create a stored procedure named 
-- GetConsumerSegmentAndRestaurantPerformance that accepts a Consumer_ID as input.

-- The procedure should:
-- 1.	Determine the consumer's "Spending Segment" based on their Budget:
-- ○	'Low' -> 'Budget Conscious'
-- ○	'Medium' -> 'Moderate Spender'
-- ○	'High' -> 'Premium Spender'
-- ○	NULL or other -> 'Unknown Budget'

-- 2.	For all restaurants rated by this consumer:
-- ○	List the Restaurant_Name.
-- ○	The Overall_Rating given by this consumer.
-- ○	The average Overall_Rating this restaurant has received from all consumers (not just the input consumer).
-- ○	A "Performance_Flag" indicating if the input consumer's rating for that restaurant is 'Above Average', 
-- 'At Average', or 'Below Average' compared to the restaurant's overall average rating.
-- ○	Rank these restaurants for the input consumer based on the Overall_Rating they gave (highest rating = rank 1).


DELIMITER $$

CREATE PROCEDURE GetConsumerSegmentAndRestaurantPerformance(
    IN p_Consumer_ID VARCHAR(20)
)
BEGIN

    SELECT
        rt.Consumer_ID,

        CASE
            WHEN c.Budget = 'Low' THEN 'Budget Conscious'
            WHEN c.Budget = 'Medium' THEN 'Moderate Spender'
            WHEN c.Budget = 'High' THEN 'Premium Spender'
            ELSE 'Unknown Budget'
        END AS Spending_Segment,

        r.Name AS Restaurant_Name,

        rt.Overall_Rating AS Consumer_Rating,

        avg_rating.Restaurant_Avg_Rating,

        CASE
            WHEN rt.Overall_Rating > avg_rating.Restaurant_Avg_Rating
                THEN 'Above Average'
            WHEN rt.Overall_Rating = avg_rating.Restaurant_Avg_Rating
                THEN 'At Average'
            ELSE 'Below Average'
        END AS Performance_Flag,

        RANK() OVER (
            ORDER BY rt.Overall_Rating DESC
        ) AS Consumer_Rating_Rank

    FROM Ratings rt

    JOIN Consumers c
        ON rt.Consumer_ID = c.Consumer_ID

    JOIN Restaurants r
        ON rt.Restaurant_ID = r.Restaurant_ID

    JOIN (
        SELECT
            Restaurant_ID,
            AVG(Overall_Rating) AS Restaurant_Avg_Rating
        FROM Ratings
        GROUP BY Restaurant_ID
    ) AS avg_rating
        ON rt.Restaurant_ID = avg_rating.Restaurant_ID

    WHERE rt.Consumer_ID = p_Consumer_ID

    ORDER BY Consumer_Rating_Rank;

END $$

DELIMITER ;

 call GetConsumerSegmentAndRestaurantPerformance('U1003');



select consumer_ID from consumers;