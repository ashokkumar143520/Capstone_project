

use Olympic_analysis;
select * from competitor_event;
select * from city;
select * from event;
select * from games;
select * from games_competitor;
select * from notable_events;
select * from Games_city;
select * from medal;
select * from noc_region;
select * from notable_events;
select * from person;
select * from person_region;
select * from sport;



-- 1 Are there any trends or patterns in the frequency of hosting Olympic Games?


SELECT
    c.city_name,
    COUNT(*) AS times_hosted
FROM games_city gc
JOIN city c ON gc.city_id = c.id
GROUP BY c.city_name
ORDER BY times_hosted DESC;

-- 2.	How has the duration of Olympic Games changed over time?

ALTER TABLE games
ALTER COLUMN games_year int;



CREATE TABLE over_time (
    games_name varchar(100) primary key ,
    season VARCHAR(10),
    games_year INT,
    start_date DATE,
    end_date DATE,
    duration_days INT
);

INSERT INTO over_time ( games_name, season, games_year, start_date, end_date, duration_days)
VALUES 
(' 2000 Summer', 'Summer', 2000, '2000-09-15', '2000-10-01',17),
('2002 Winter ', 'Winter', 2002, '2002-02-08', '2002-02-24', 17),
( '2004 Summer', 'Summer', 2004, '2004-08-13', '2004-08-29', 17),
( '2006 Winter', 'Winter', 2006, '2006-02-10', '2006-02-26', 17),
( '2008 Summer', 'Summer', 2008, '2008-08-08', '2008-08-24', 17),
('2010 Winter', 'Winter', 2010, '2010-02-12', '2010-02-28', 17),
('2012 Summer', 'Summer', 2012, '2012-07-27', '2012-08-12', 17),
('2014 Winter', 'Winter', 2014, '2014-02-07', '2014-02-23', 17),
('2016 Summer', 'Summer', 2016, '2016-08-05', '2016-08-21', 17),
('2018 Winter', 'Winter', 2018, '2018-02-09', '2018-02-25', 17);

 select * from over_time;



SELECT 
    games_year,
    season,
    games_name,
    start_date,
    end_date,
    DATEDIFF(day, start_date, end_date) + 1 AS duration_days
FROM 
    over_time
ORDER BY 
    games_year;




SELECT 
    g.games_year,
    COUNT(DISTINCT e.id) AS event_count
FROM games g
JOIN games_competitor gc ON g.id = gc.games_id
JOIN competitor_event ce ON gc.id = ce.competitor_id
JOIN event e ON ce.event_id = e.id
GROUP BY g.games_year
ORDER BY g.games_year;


-- 3 Are there any notable events or occurrences associated with specific Olympic Games?

SELECT 
    g.games_year,
    c.city_name,
    g.season,
    ne.notable_event AS notable_events
FROM games g
join notable_events ne on ne.games_year = g.games_year
JOIN games_city gc On g.id = gc.games_id
join city c on c.id = gc.city_id
ORDER BY g.games_year;



-- 4 Are there any emerging sports that have been recently added to the Olympics?

select * from sport;
select * from Event;


SELECT 
    s.sport_name,
    g.games_year,
    g.season
FROM sport s
JOIN event e ON s.id = e.sport_id
JOIN competitor_event ce ON ce.event_id = e.id
JOIN games_competitor gc on gc.id = ce.competitor_id
JOIN games g ON gc.games_id = g.id
WHERE g.games_year >= 2016
ORDER BY g.games_year;


-- 5 How has the popularity of certain sports changed over the years?

SELECT 
    s.sport_name,
    g.games_year,
    COUNT(DISTINCT gc.person_id) AS number_of_athletes
FROM sport s
JOIN event e ON s.id = e.sport_id
JOIN competitor_event ce ON ce.event_id = e.id
JOIN games_competitor gc on gc.id = ce.competitor_id
JOIN games g ON gc.games_id = g.id
GROUP BY s.sport_name, g.games_year
ORDER BY s.sport_name, g.games_year;

-- 6 Are there any sports that are specific to a particular region or culture?


select * from competitor_event;
select * from games_competitor;
select * from person_region;
select * from person;



SELECT
    s.sport_name,
    nr.region_name,
    COUNT(*) AS medal_count
FROM
    sport s
JOIN
    event e ON s.id = e.sport_id
JOIN
    competitor_event ce ON e.id = ce.event_id
JOIN
    games_competitor gc ON ce.competitor_id = gc.id
JOIN
    person_region pr ON gc.person_id = pr.person_id
JOIN
    noc_region nr ON pr.region_id = nr.rigion_id
WHERE
    ce.medal_id IS NOT NULL
GROUP BY
    s.sport_name, nr.region_name
ORDER BY
    s.sport_name, medal_count DESC;



--7 Are there any sports that have a higher number of events for one gender compared to others?


	SELECT
    s.sport_name,
    p.gender,
    COUNT(DISTINCT e.id) AS num_events
FROM event e
JOIN competitor_event ce ON e.id = ce.event_id
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person p ON gc.person_id = p.id
JOIN sport s ON e.sport_id = s.id
GROUP BY
    s.sport_name, p.gender
ORDER BY
    s.sport_name, p.gender;


-- 8 Are there any new events that have been introduced in recent editions of the Olympics?

SELECT 
    s.sport_name,
    e.event_name,
    MIN(g.games_year) AS first_appearance_year
FROM event e
JOIN sport s ON e.sport_id = s.id
JOIN competitor_event ce ON e.id = ce.event_id
JOIN games_competitor gc on gc.id = ce.competitor_id
JOIN games g ON gc.games_id = g.id
GROUP BY s.sport_name, e.event_name
HAVING MIN(g.games_year) < 2016
ORDER BY first_appearance_year DESC;

-- 9 Are there any events that have been discontinued or removed from the Olympics?

SELECT
    e.event_name,
    s.sport_name,
    MAX(g.games_year) AS last_appearance_year
FROM event e
JOIN sport s ON e.sport_id = s.id
JOIN competitor_event ce ON e.id = ce.event_id
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN games g ON gc.games_id = g.id
GROUP BY e.event_name, s.sport_name
HAVING
    MAX(g.games_year) < (
        SELECT MAX(games_year) FROM games
    )
ORDER BY last_appearance_year DESC;


-- 10 Are there any notable trends in the height and weight of participants over time?

SELECT
    g.games_year,
    ROUND(AVG(p.height), 1) AS avg_height_cm,
    ROUND(AVG(p.weight), 1) AS avg_weight_kg
FROM
    person p
JOIN games_competitor gc ON p.id = gc.person_id
JOIN games g ON gc.games_id = g.id
WHERE
    p.height IS NOT NULL AND p.weight IS NOT NULL
GROUP BY
    g.games_year
ORDER BY
    g.games_year;


	-- 11 Are there any dominant countries or regions in specific sports or events?

	SELECT
    s.sport_name,
    nr.region_name,
    COUNT(*) AS medal_count
FROM competitor_event ce
JOIN event e ON ce.event_id = e.id
JOIN sport s ON e.sport_id = s.id
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person_region pr ON gc.person_id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
WHERE
    ce.medal_id IS NOT NULL
GROUP BY
    s.sport_name, nr.region_name
ORDER BY
    s.sport_name, medal_count DESC;


	SELECT 
    nr.region_name,
    s.sport_name,
    COUNT(ce.medal_id) AS total_medals
FROM competitor_event ce
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person p ON gc.person_id = p.id
JOIN person_region pr ON p.id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
JOIN event e ON ce.event_id = e.id
JOIN sport s ON e.sport_id = s.id
WHERE ce.medal_id IS NOT NULL
GROUP BY nr.region_name, s.sport_name
ORDER BY s.sport_name, total_medals DESC;



-- 12 What factors contribute to the success or performance of participants from different countries?


SELECT
    nr.region_name,
    ROUND(AVG(gc.age), 1) AS avg_age,
    ROUND(AVG(p.height), 1) AS avg_height,
    ROUND(AVG(p.weight), 1) AS avg_weight,
    COUNT(*) AS medal_count
FROM competitor_event ce
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person p ON gc.person_id = p.id
JOIN person_region pr ON p.id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
WHERE
    ce.medal_id IS NOT NULL
GROUP BY
    nr.region_name
ORDER BY
    medal_count DESC;



-- 13 What factors contribute to the success or performance of participants from different countries?
	SELECT
    nr.region_name,
    ROUND(AVG(gc.age), 1) AS avg_age,
    ROUND(AVG(p.height), 1) AS avg_height,
    ROUND(AVG(p.weight), 1) AS avg_weight,
    COUNT(*) AS total_medals
FROM competitor_event ce
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person p ON gc.person_id = p.id
JOIN person_region pr ON p.id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
WHERE
    ce.medal_id IS NOT NULL
GROUP BY
    nr.region_name
ORDER BY
    total_medals DESC;



	-- 14 Are there any sports or events that have a higher number of medalists from a specific region?

SELECT
    s.sport_name,
    nr.region_name,
    COUNT(*) AS medal_count
FROM competitor_event ce
JOIN event e ON ce.event_id = e.id
JOIN sport s ON e.sport_id = s.id
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person_region pr ON gc.person_id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
WHERE
    ce.medal_id IS NOT NULL
GROUP BY
    s.sport_name, nr.region_name
ORDER BY
    s.sport_name, medal_count DESC;


	-- 15 What are some notable instances of unexpected or surprising medal wins?

	SELECT
    nr.region_name,
    s.sport_name,
    m.medal_name,
    COUNT(*) AS medals_won
FROM competitor_event ce
JOIN event e ON ce.event_id = e.id
JOIN sport s ON e.sport_id = s.id
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person_region pr ON gc.person_id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
JOIN medal m ON ce.medal_id = m.id
GROUP BY nr.region_name, s.sport_name, m.medal_name

ORDER BY nr.region_name, s.sport_name;



-- 16 Are there any regions that have experienced significant growth or decline in Olympic participation?

SELECT
    g.games_year,
    nr.region_name,
    COUNT(DISTINCT gc.person_id) AS competitor_count
FROM games g
JOIN games_competitor gc ON g.id = gc.games_id
JOIN person_region pr ON gc.person_id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
GROUP BY
    g.games_year, nr.region_name
ORDER BY
    nr.region_name, g.games_year;




	-- 17 How do cultural or geographical factors influence the performance of regions in specific sports?

	SELECT
    nr.region_name,
    s.sport_name,
    COUNT(*) AS medals_won
FROM competitor_event ce
JOIn event e ON ce.event_id = e.id
JOIN sport s ON e.sport_id = s.id
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN games g on g.id = gc.games_id
JOIN person_region pr ON gc.person_id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
    WHERE
    ce.medal_id IS NOT NULL
    AND g.games_year >= 2000  -- Analyze only modern Games

GROUP BY
    nr.region_name, s.sport_name
ORDER BY
    s.sport_name, medals_won DESC;


	



--18 Are there any regions that have had a notable impact on the overall medal tally?
	SELECT
    nr.region_name,
    COUNT(*) AS total_medals
FROM competitor_event ce
JOIN games_competitor gc ON ce.competitor_id = gc.id
JOIN person_region pr ON gc.person_id = pr.person_id
JOIN noc_region nr ON pr.region_id = nr.rigion_id
WHERE
    ce.medal_id IS NOT NULL
GROUP BY
    nr.region_name
ORDER BY
    total_medals DESC;