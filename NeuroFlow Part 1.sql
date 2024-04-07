--- Determine how many patients fall into each category

with scoring_scale as (

select *, case
	when score between 0 and 5 then 'Low to Minimal'
	when score between 6 and 10 then 'Mild'
	when score between 11 and 15 then 'Moderate'
	when score between 16 and 21 then 'Severe' end as severity
	from GAD_7 G)

select severity,
COUNT(distinct patient_id) as pt_cnt
from scoring_scale
group by severity
order by pt_cnt DESC;

--- Find the top 10 patients by the sum of all their scores

select
	patient_id, 
	SUM(score) as total
from GAD_7 G
group by PATIENT_ID
order by total desc
limit 10;

--- find the number of patients by year and month, and find the average score for each grouping

with mnth_groups as (

select 
	patient_id,
	"date"::date as casted_date,
	DATE_PART('year',"date"::date) as yr,
	DATE_PART('month',"date"::date) as mnth,
	patient_date_created::date as casted_date_created,
	score
from GAD_7 G)
select
	yr,
	mnth,
 	COUNT(distinct patient_id) as pt_cnt,
 	ROUND(AVG(score),2) as avg_score
from mnth_groups
group by yr, mnth
order by avg_score DESC;



--- find the patient count and average score for each severity level, grouped by month and year

with severity_breakdown as (

select 
	patient_id,
	"date"::date as casted_date,
	DATE_PART('year',"date"::date) as yr,
	DATE_PART('month',"date"::date) as mnth,
	patient_date_created::date as casted_date_created,
	score,
	case
		when score between 0 and 5 then 'Low to Minimal'
		when score between 6 and 10 then 'Mild'
		when score between 11 and 15 then 'Moderate'
		when score between 16 and 21 then 'Severe' end as severity
		from GAD_7 G)

select
	severity,
	yr,
	mnth,
	COUNT(distinct patient_id),
	AVG(score)
from severity_breakdown
group by severity, yr, mnth;
























