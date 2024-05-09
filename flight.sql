


SELECT * FROM campusx.flights;  

-- 1. Find the month with most number of flights

SELECT monthname(Date_of_Journey),count(*) FROM campusx.flights
group by monthname(Date_of_Journey)
order by count(*) deSc 
limit 1;

-- 2. Which week day has most costly flights
SELECT dayname(Date_of_Journey),avg(Price) FROM campusx.flights
group by dayname(Date_of_Journey)
order by count(*) deSc 
limit 1;

-- 3. Find number of indigo flights every month
SELECT monthname(Date_of_Journey) as Month,count(*) FROM campusx.flights
where Airline like 'Indigo'
group by monthname(Date_of_Journey)
order by Month(Date_of_Journey);

-- 4 Find list of all flights that depart between 10AM and 2PM from Delhi to Bangl
SELECT  distinct Airline from flights
where Source ='Banglore' and Destination = 'Delhi' and 
Dep_Time >'10:00:00' and Dep_Time<'14:00:00';

-- 5. Find the number of flights departing on weekends from Bangalore 
SELECT   count(Airline)  from flights
where Source ='Banglore' and 
dayname(Date_of_Journey) in ('saturday','sunday');

-- 6. Calculate the arrival time for all flights by adding the duration to the departur

ALTER TABLE flights ADD COLUMN departure DATETIME;

UPDATE flights
SET departure = STR_TO_DATE(CONCAT(date_of_journey,' ',dep_time),'%Y-%m-%d %H:%i');

ALTER TABLE flights
ADD COLUMN duration_mins INTEGER,
ADD COLUMN arrival DATETIME;

update flights
Set duration_mins = 
case 
     when duration like'%h%m' then
        SUBSTRING_INDEX(duration,'h',1)*60+
        SUBSTRING_INDEX(SUBSTRING_INDEX(duration,'',1),'m',1)
	 when duration like'%h' then
        SUBSTRING_INDEX(duration,'h',1)*60
	 when duration like'%m' then
        SUBSTRING_INDEX(duration,'m',1)
 end;       
 
 SELECT  *  from flights;
 
 UPDATE flights
SET arrival = DATE_ADD(departure,INTERVAL duration_mins MINUTE);

 SELECT  *  from flights;
 SELECT TIME(arrival) FROM flights;
 
 
 -- 7. Calculate the arrival date for all the flights

SELECT DATE(arrival) FROM flights;


SELECT * FROM flights;

-- 8. Find the number of flights which travel on multiple dates.
SELECT COUNT(*) FROM flights
WHERE DATE(departure) != DATE(arrival);

-- 9.Calculate the average duration of flights between all city pairs. The answer should In xh ym format
SELECT source,destination,
TIME_FORMAT(SEC_TO_TIME(AVG(duration_mins)*60),'%kh %im') AS 'avg_duration' FROM flights
GROUP BY source,destination;

-- 10. Find all flights which departed before midnight but arrived at their destination after midnight having only 0 stops.
SELECT * FROM flights
WHERE total_stops = 'non-stop' AND
DATE(departure) < DATE(arrival);

-- 11. Find quarter wise number of flights for each airline
SELECT airline,QUARTER(departure),COUNT(*)
FROM flights
GROUP BY airline,QUARTER(departure);


-- 12. Average time duration for flights that have non stop vs more than 1 stops
WITH temp_table AS (SELECT *,
CASE 
	WHEN total_stops = 'non-stop' THEN 'non-stop'
    ELSE 'with stop'
END AS 'temp'
FROM flights)

SELECT temp,
TIME_FORMAT(SEC_TO_TIME(AVG(duration_mins)*60),'%kh %im') 
AS 'avg_duration'
FROM temp_table
GROUP BY temp;


-- 	13. Find all Air India flights in a given date range originating from Delhi

-- 1st Mar 2019 to 10th Mar 2019 
SELECT * FROM flights
WHERE source = 'Delhi' AND
DATE(departure) BETWEEN '2019-03-01' AND '2019-03-10';

-- 14. Find the longest flight of each airline
SELECT airline,
TIME_FORMAT(SEC_TO_TIME(MAX(duration_mins)*60),'%kh %im') AS 'max_duration'
FROM flights
GROUP BY airline
ORDER BY MAX(duration_mins) DESC;

-- 	15. Make a weekday vs time grid showing frequency of flights from Banglore and Delhi

SELECT DAYNAME(departure),
SUM(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN 1 ELSE 0 END) AS '12AM - 6AM',
SUM(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN 1 ELSE 0 END) AS '6AM - 12PM',
SUM(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN 1 ELSE 0 END) AS '12PM - 6PM',
SUM(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN 1 ELSE 0 END) AS '6PM - 12PM'
FROM flights
WHERE source = 'Banglore' AND destination = 'Delhi'
GROUP BY DAYNAME(departure)
ORDER BY DAYOFWEEK(departure) ASC;

-- 	16. Make a weekday vs time grid showing avg flight price from Banglore and Delhi

SELECT DAYNAME(departure),
AVG(CASE WHEN HOUR(departure) BETWEEN 0 AND 5 THEN price ELSE NULL END) AS '12AM - 6AM',
AVG(CASE WHEN HOUR(departure) BETWEEN 6 AND 11 THEN price ELSE NULL END) AS '6AM - 12PM',
AVG(CASE WHEN HOUR(departure) BETWEEN 12 AND 17 THEN price ELSE NULL END) AS '12PM - 6PM',
AVG(CASE WHEN HOUR(departure) BETWEEN 18 AND 23 THEN price ELSE NULL END) AS '6PM - 12PM'
FROM flights
WHERE source = 'Banglore' AND destination = 'Delhi'
GROUP BY DAYNAME(departure)
ORDER BY DAYOFWEEK(departure) ASC;


