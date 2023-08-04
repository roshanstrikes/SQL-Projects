
--Sum of casualties in Year 2022 :-

SELECT SUM(number_of_casualties) AS CY_casualties 
FROM road_accident
WHERE YEAR(accident_date)= '2022';

--count of accidents in CY 2022

SELECT COUNT(accident_index) AS CY_accidents 
FROM road_accident
WHERE YEAR(accident_date)= '2022';

-- Sum of Fatal casualties 

SELECT SUM(number_of_casualties) AS Fatal_casualties 
FROM road_accident
WHERE accident_severity= 'Fatal'

-- CY Serious Casualties

SELECT SUM(number_of_casualties) AS CY_Serious_casualties 
FROM road_accident
WHERE YEAR(accident_date)= '2022' AND accident_severity= 'Serious'

-- Percentage of Slight casualties

SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) *100 /
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident) as PCT 
FROM road_accident
WHERE accident_severity= 'Slight'

-- CY Casualties by vehicle type

SELECT 
	CASE
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		WHEN vehicle_type IN ('Motorcycle 125cc and under', 'Motercycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle') THEN 'Bike'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8-16 passenger seats)') THEN 'Bus'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw and under') THEN 'Van'
		ELSE 'Other'
	END As Vehicle_group,
	SUM(number_of_casualties) as CY_casualties
	FROM road_accident
	WHERE YEAR(accident_date) = '2022'
	GROUP BY
		CASE
			WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
			WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
			WHEN vehicle_type IN ('Motorcycle 125cc and under', 'Motercycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle') THEN 'Bike'
			WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8-16 passenger seats)') THEN 'Bus'
			WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw and under') THEN 'Van'
			ELSE 'Other'
		END

-- CY & PY casualties monthly trend

SELECT DATENAME(MONTH, accident_date) AS Month_Name, SUM(number_of_casualties) as CY_casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH, accident_date)

----##similarly, we can find for the year 2021

-- Casualties by road type

SELECT road_type, SUM(number_of_casualties) as CY_casualties FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type

-- Casualties by urban/rural

SELECT urban_or_rural_area, SUM(number_of_casualties) AS Total_casualties, CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) *100 / 
(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022') as PCT_casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

-- Casualties PCT by light condition

SELECT

	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Night'
	END as Light_Condition,
	CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100 /
	(SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident
	WHERE YEAR(accident_date) = '2022') AS DECIMAL(10,2))
	AS CY_Casualties_PCT
	FROM road_accident
	WHERE YEAR(accident_date) = '2022'
	GROUP BY
	CASE
			WHEN light_conditions IN ('Daylight') THEN 'Day'
			WHEN light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Night'
		END


-- Top 10 locations by No. of casualties

SELECT Top 10 local_authority, SUM(number_of_casualties) AS Total_casualties
FROM road_accident
GROUP BY local_authority
ORDER BY local_authority DESC
