-- Select the schema to work on
USE AVIATION_ANALYSIS;

-- View tables
SELECT * FROM aircarft_data;
SELECT * FROM airport_details;
SELECT * FROM injuries_report;
SELECT * FROM investigation_report;

-- Evaluating Total Passengers in each flight

ALTER TABLE injuries_report
Add Total_Passengers int;

Update injuries_report
set Total_Passengers = Total_fatal_Injuries + Total_serious_Injuries +Total_Minor_Injuries+Total_Uninjured;

SELECT b.Event_Date, b.Country, b.Purpose_of_Flight, a.Total_fatal_Injuries, a.Total_serious_Injuries,
a.Total_Minor_Injuries, a.Total_Uninjured, a.Total_Passengers
FROM injuries_report a JOIN investigation_report b
ON a.Event_id = b.Event_id 
order by event_date;

-- Looking at cases where Injuries were not recorded

SELECT b.Event_Date, b.Country, b.Purpose_of_Flight, a.Total_fatal_Injuries, a.Total_serious_Injuries,
a.Total_Minor_Injuries, a.Total_Uninjured, a.Total_Passengers
FROM injuries_report a JOIN investigation_report b
ON a.Event_id = b.Event_id
WHERE Total_Passengers = 0
order by event_date;

-- Evaluating Percentage of Fatality in each flight and streamlining to Nigeria and Australia

SELECT b.Event_Date, b.Country, b.Purpose_of_Flight, a.Total_fatal_Injuries, a.Total_Passengers, 
(a.Total_fatal_Injuries/NULLIF(a.Total_Passengers,0)*100) as PercentFatality
FROM injuries_report a JOIN investigation_report b
ON a.Event_id = b.Event_id
WHERE COUNTRY LIKE '%Nigeria'
order by event_date;

SELECT b.Event_Date, b.Country, b.Purpose_of_Flight, a.Total_fatal_Injuries, a.Total_Passengers, 
(a.Total_fatal_Injuries/NULLIF(a.Total_Passengers,0)*100) as PercentFatality
FROM injuries_report a JOIN investigation_report b
ON a.Event_id = b.Event_id
WHERE COUNTRY LIKE '%Australia'
order by event_date;

-- Countries with highest number of accidents
SELECT Country, COUNT(Event_Id) as Number_of_accidents
FROM investigation_report
Group by  Country
Order by Number_of_accidents desc;

-- Countries with the largest percent fatality

WITH fatality_percent as (
SELECT b.Event_Date, b.Country, b.Purpose_of_Flight, a.Total_fatal_Injuries, a.Total_Passengers, 
(a.Total_fatal_Injuries/NULLIF(a.Total_Passengers,0)*100) as PercentFatality
FROM injuries_report a JOIN investigation_report b
ON a.Event_id = b.Event_id)

SELECT Country, Max(PercentFatality) as largest_percent_fatality
FROM fatality_percent
GROUP BY Country
ORDER BY largest_percent_fatality desc;

-- Purpose of flight by number of accidents

SELECT Purpose_of_flight, COUNT(Event_Id) as Number_of_accidents
FROM investigation_report
Where Purpose_of_flight is not null
Group by  Purpose_of_flight
Order by Number_of_accidents desc;

-- Number of accidents recorded per year 
SELECT  Year(Event_Date) as Accident_Year, COUNT(Event_Id) as Number_of_accidents
FROM investigation_report
Group by Accident_Year
# Having Accident_Year > 2000
Order by Number_of_accidents desc;

-- Extent of Aircraft damage and fatality

SELECT a.Aircraft_damage, sum(i.Total_fatal_Injuries) as Fatal_Injuries, COUNT(i.Event_Id) as Number_of_accidents
FROM aircraft_data a
JOIN injuries_report i
on a.Accident_Number = i.Accident_Number
where a.Aircraft_damage is not null
Group by a.Aircraft_damage
Order by 2 desc;

-- Analysing the Causes of Accidents

With CrashCause as
(
SELECT Report_Status, COUNT(Report_Status),
Case when Report_Status LIKE '%Pilot error%' then 'Pilot error'
	 when Report_Status LIKE '%weather%' then  'Windcaused' 
	 when Report_Status LIKE '%Bird%' then 'Bird/Wildlifecaused' 
	 when Report_Status LIKE '%Engine%' then 'Engine Failure'	
	 when Report_Status LIKE '%Control%' then 'Loss of control'
	 when Report_Status LIKE '%Probable cause%' then 'Unidentified'
	 else  'Other causes'
End as Probable_cause
FROM investigation_report
WHERE Report_Status is NOT null
Group by Report_Status)
SELECT * FROM CrashCause;

CREATE VIEW Report AS
SELECT Case when Report_Status LIKE '%Pilot error%' then 'Pilot error'
	 when Report_Status LIKE '%weather%' then  'Windcaused' 
	 when Report_Status LIKE '%Bird%' then 'Bird/Wildlifecaused' 
	 when Report_Status LIKE '%Engine%' then 'Engine Failure'	
	 when Report_Status LIKE '%Control%' then 'Loss of control'
	 when Report_Status LIKE '%Probable cause%' then 'Unidentified'
	 else  'Other causes'
End as Probable_cause FROM investigation_report
WHERE Report_Status is NOT null;

UPDATE investigation_report
SET Report_Status = (select  Probable_cause from Report);

-- Creating a view of data to be used later

CREATE VIEW AviationCases as
SELECT i.Event_Date, i.Country, i.Location, i.Purpose_of_Flight, a.Aircraft_damage, 
	   inj.Total_fatal_Injuries, inj.Total_serious_Injuries, inj.Total_Minor_Injuries, inj.Total_Uninjured, inj.Total_Passengers
FROM investigation_report i 
JOIN injuries_report inj
	on i.Event_Id = inj.Event_Id
	and i.Accident_Number = inj.Accident_Number
join aircraft_data a 
on inj.Accident_Number = a.Accident_Number
WHERE i.Event_Id is not null;

select * from AviationCases;

-- Aircraft and carrier information

select a.aircraft_damage, a.aircraft_category, a.amateur_built, a.Air_carrier, b.Airport_name , count(i.total_passengers) from aircraft_data a 
join airport_details b on a.registration_number = b.registration_number 
join injuries_report i on a.accident_number = i.accident_number 
where a.Air_carrier is not null and a.Air_carrier != "unknown"
group by a.Air_carrier, a.aircraft_damage, a.aircraft_category, a.amateur_built,  b.Airport_name ;

-- Create the virtual table view
CREATE VIEW crash_cause AS
SELECT
  accident_number ,
  CASE WHEN Report_Status LIKE '%Pilot Error%' THEN 'Pilot error'
    WHEN Report_Status LIKE '%Weather%' THEN 'Windcaused'
    WHEN Report_Status LIKE '%Bird%' THEN 'Bird/Wildlifecaused'
    WHEN Report_Status LIKE '%Engine%' THEN 'Engine Failure'
    WHEN Report_Status LIKE '%Control%' THEN 'Loss of control'
    WHEN Report_Status LIKE '%Probable Cause%' THEN 'Unidentified'
    ELSE 'Other causes'
  END AS Crash_Cause
FROM investigation_report;

select * from crash_cause;
-- The above view has been exported into csv in the name of report_status
