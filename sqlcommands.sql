SELECT dist_code, SUM(documents_registered_rev) AS total_revenue
FROM ts_ipass.fact_stamps
WHERE SUBSTRING(month, 1,4) IN ('2019','2020','2021','2022')
GROUP BY dist_code
ORDER BY total_revenue DESC
LIMIT 5;



SELECT dist_code,SUM(estamps_challans_rev) ,SUM(document_registered_rev) , (SUM(estamps_challans_rev) - SUM(document_registered_rev)) AS contribution_difference
FROM ts_ipass.fact_stamps
WHERE SUBSTRING(month, 1,4) ='2022'
AND estamps_challans_rev > document_registered_rev
GROUP BY dist_code
ORDER BY contribution_difference DESC
LIMIT 5;



/* List down the top 3 and bottom 3 districts that have shown the highest 
and lowest vehicle sales growth during FY 2022 compared to FY petrol
2021? */

SELECT
    dist_code,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_petrol ELSE 0 END) AS petrol_2021,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_petrol ELSE 0 END) AS petrol_2022,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_petrol ELSE 0 END) - 
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_petrol ELSE 0 END) AS petrol_difference
FROM
    ts_ipass.fact_transport
WHERE
    SUBSTRING(month, 1, 4) IN ('2021', '2022')
GROUP BY
    dist_code
ORDER BY
    petrol_difference DESC 
LIMIT 3;

SELECT
    dist_code,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_petrol ELSE 0 END) AS petrol_2021,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_petrol ELSE 0 END) AS petrol_2022,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_petrol ELSE 0 END) - 
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_petrol ELSE 0 END) AS petrol_difference
FROM
    ts_ipass.fact_transport
WHERE
    SUBSTRING(month, 1, 4) IN ('2021', '2022')
GROUP BY
    dist_code
ORDER BY
    petrol_difference DESC
LIMIT 3;
-- Create a new table and insert the query results into it

CREATE TABLE ts_ipass.sql_queries AS
SELECT
    dist_code,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_petrol ELSE 0 END) AS petrol_2021,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_petrol ELSE 0 END) AS petrol_2022,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_petrol ELSE 0 END) - 
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_petrol ELSE 0 END) AS petrol_difference
FROM
    ts_ipass.fact_transport
WHERE
    SUBSTRING(month, 1, 4) IN ('2021', '2022')
GROUP BY
    dist_code
ORDER BY
    petrol_difference DESC;

-- Optionally, you can add a primary key to the new table if needed
-- ALTER TABLE new_table_name ADD PRIMARY KEY (dist_code);


CREATE TABLE ts_ipass.diesel AS
SELECT
    dist_code,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_diesel ELSE 0 END) AS diesel_2021,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_diesel ELSE 0 END) AS diesel_2022,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_diesel ELSE 0 END) - 
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_diesel ELSE 0 END) AS diesel_difference
FROM
    ts_ipass.fact_transport
WHERE
    SUBSTRING(month, 1, 4) IN ('2021', '2022')
GROUP BY
    dist_code
ORDER BY
    diesel_difference DESC;
    

CREATE TABLE ts_ipass.electric AS
SELECT
    dist_code,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_electric ELSE 0 END) AS electric_2021,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_electric ELSE 0 END) AS electric_2022,
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2021' THEN fuel_type_electric ELSE 0 END) - 
    SUM(CASE WHEN SUBSTRING(month, 1, 4) = '2022' THEN fuel_type_electric ELSE 0 END) AS electric_difference
FROM
    ts_ipass.fact_transport
WHERE
    SUBSTRING(month, 1, 4) IN ('2021', '2022')
GROUP BY
    dist_code
ORDER BY
    electric_difference DESC;
    
DROP TABLE ts_ipass.diesel;
DROP TABLE ts_ipass.electric;

SELECT sum(investment),sector,dist_code
FROM ts_ipass.fact
WHERE SUBSTRING(month, 7, 9) IN ('2019','2020','2021', '2022')
GROUP BY sector
ORDER BY sum(investment); 

SELECT sum(investment),sector
FROM ts_ipass.fact
GROUP BY sector
ORDER BY sum(investment) DESC; 

SELECT COUNT(distinct(dist_code)) FROM ts_ipass.fact;

CREATE TABLE ts_ipass.investments AS
SELECT dist_code, SUM(investment) AS investment_2021
FROM ts_ipass.fact
WHERE
    SUBSTRING(month, 7, 9) IN ('2021')
GROUP BY dist_code;
SELECT * FROM ts_ipass.investments;
DROP TABLE ts_ipass.investments;

ALTER TABLE ts_ipass.investments
ADD investment_2022 VARCHAR(255) ; 

ALTER TABLE ts_ipass.investments
ADD stamp_2021 VARCHAR(255) ; 

UPDATE ts_ipass.investments
SET investment_2022 = (
SELECT SUM(investment)
FROM ts_ipass.fact
WHERE
    SUBSTRING(month, 7, 9) = '2022' AND
fact.dist_code = investments.dist_code
);

UPDATE ts_ipass.investments
SET stamp_2021 = (
SELECT SUM(estamps_challans_rev)
FROM ts_ipass.fact_stamps
WHERE
    SUBSTRING(month, 1, 4) = '2021' AND
fact_stamps.dist_code = investments.dist_code
);

ALTER TABLE ts_ipass.investments
ADD stamp_2022 VARCHAR(255) ; 

UPDATE ts_ipass.investments
SET stamp_2022 = (
SELECT SUM(estamps_challans_rev)
FROM ts_ipass.fact_stamps
WHERE
    SUBSTRING(month, 1, 4) = '2022' AND
fact_stamps.dist_code = investments.dist_code
);

ALTER TABLE ts_ipass.investments
ADD vehicles_2021 VARCHAR(255) ; 

ALTER TABLE ts_ipass.investments
ADD vehicles_2022 VARCHAR(255) ; 

UPDATE ts_ipass.investments AS i
SET i.vehicles_2022 = (
    SELECT SUM(
        vehicleClass_Agriculture +
		vehicleClass_AutoRickshaw +
        vehicleClass_MotorCar +
        vehicleClass_MotorCycle +
        vehicleClass_others)
    FROM ts_ipass.fact_transport 
    WHERE
        SUBSTRING(month, 1, 4) = '2022' AND
        fact_transport.dist_code = i.dist_code
);


SELECT * FROM ts_ipass.investments;

ALTER TABLE ts_ipass.investments
ADD vehicles_difference VARCHAR(255); 

UPDATE ts_ipass.investments AS i
SET vehicles_difference  = (
    SELECT SUM(
        vehicleClass_Agriculture +
		vehicleClass_AutoRickshaw +
        vehicleClass_MotorCar +
        vehicleClass_MotorCycle +
        vehicleClass_others)
    FROM ts_ipass.fact_transport 
    WHERE
        SUBSTRING(month, 1, 4) = '2022' AND
        fact_transport.dist_code = i.dist_code
);

SELECT distinct sector FROM ts_ipass.fact;
