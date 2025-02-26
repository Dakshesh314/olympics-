/*RESEARCH PROJECT ON OLYMPICS*/
/*Creating a database*/
create database Olympics;

/*Use Olympics as a database*/
use Olympics;

/*Creating a table for athletes and events details*/
create table athlete_events
(ID	int,
Name varchar(100),
Sex	varchar(10),
Age	int,
Height int,
Weight int,
Team varchar(100),
NOC varchar(100),	
Games varchar(100),	
Year int,
Season varchar(100),	
City varchar(100),	
Sport varchar(100),	
Event varchar(100),	
Medal varchar(100)	
);

/*Now a query to look at table athlete_events in undefined order.*/
select * from athlete_events;

/*noc_regions table details are imported directly as the file is small*/
select * from noc_regions;

/*Business Analysis on the Olympics Dataset*/


/*1. No. of Regions in the dataset*/
select count(distinct region) as TotalRegions
from noc_regions;	
/*So there are 207 Countries that participated in the Olympics*/


/*2. List of the total number of females and males by gender?*/
select sex, count(*) as TotalNo
from athlete_events
group by sex
order by 2;


/*3. The total number of females and males by city. A query that also computes the male to female gender ratio in each city*/
SELECT city, 
       COUNT(*) AS TotalNo, 
       SUM(CASE WHEN sex = 'M' THEN 1 ELSE 0 END) AS male,
       SUM(CASE WHEN sex = 'F' THEN 1 ELSE 0 END) AS female,
       IFNULL(
           SUM(CASE WHEN sex = 'M' THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN sex = 'F' THEN 1 ELSE 0 END), 0), 
           0
       ) AS Ratio
FROM athlete_events
GROUP BY city
ORDER BY male DESC, female DESC
LIMIT 20;


/*4. No. of males vs females who won medals*/
select medal, sum(case when sex = "M" then 1 else 0 end) as MedalByMale, sum(case when sex = "F" then 1 else 0 end) as MedalByfemale 
from athlete_events
where medal = "gold";

select medal, sum(case when sex = "M" then 1 else 0 end) as MedalByMale, sum(case when sex = "F" then 1 else 0 end) as MedalByfemale 
from athlete_events
where medal = "silver";

select medal, sum(case when sex = "M" then 1 else 0 end) as MedalByMale, sum(case when sex = "F" then 1 else 0 end) as MedalByfemale 
from athlete_events
where medal = "bronze";


/*5. No. of Gold medals from each Country. Top 5 Countries*/
select medal, count(*) as NoOfGold, region
from athlete_events a inner join noc_regions n on a.noc = n.noc
where medal = "gold"
group by region
order by 2 desc
limit 5;

/*6. List the country that has the highest number of participants sorted by the season. (2-level ordering)*/
SELECT team, 
       MAX(season) AS season, 
       COUNT(*) AS Participants
FROM athlete_events
GROUP BY team
ORDER BY Participants DESC, season
LIMIT 10;

/*7. Country that has won the highest number of medals and in which year*/
SELECT Team, 
       COUNT(Medal) AS Total, 
       MAX(Year) AS LastYear
FROM athlete_events
WHERE Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Team
ORDER BY Total DESC;



/*8. Medal Attained in Rio Olympics 2016*/
select team, year, count(medal) as NoOfGoldMedals
from athlete_events
where medal = "gold" and year = 2016
group by team
order by 3 desc
limit 20;


/*9. No. of athletes in Summer season vs Winter season*/
select season, sum(case when season = "summer" then 1 else 0 end) as SummerSport, sum(case when season = "winter" then 1 else 0 end) as WinterSport 
from athlete_events
where year >= 1986
group by season;


/*10. City that is most suitable for multiple games to be played?*/
SELECT city, 
       COUNT(*) AS TotalGamesPlayed
FROM athlete_events
GROUP BY city
ORDER BY TotalGamesPlayed DESC;


/*11. List the top 10 most popular sports events for women?*/
select event, count(*) as PopularSports
from athlete_events
where sex = "F"
group by event 
order by 2 desc
limit 10;

/*12. List the top 10 most popular sports events for men?*/
select event, count(*) as PopularSports
from athlete_events
where sex = "M"
group by event 
order by 2 desc
limit 10;


/*13. The number of participants in each sport and the event where it held. The participants should be sorted by their height and weight?*/
SELECT sport, 
       event, 
       COUNT(*) AS Participants, 
       MAX(region) AS region, 
       ROUND(AVG(height), 2) AS avg_height, 
       ROUND(AVG(weight), 2) AS avg_weight
FROM athlete_events a 
INNER JOIN noc_regions n ON a.noc = n.noc
GROUP BY sport, event
ORDER BY Participants DESC, region DESC, avg_height DESC, avg_weight DESC
LIMIT 20;
