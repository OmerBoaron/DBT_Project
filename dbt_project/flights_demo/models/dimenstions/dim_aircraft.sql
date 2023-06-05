{{config (materialized='table')}}



with aircraft as
(
	select *,
		case when range > 5600 then 'high' else 'low'
		end as ranges_condition,
	model ->> 'en' as model_english_name,
	model ->> 'ru' as model_russian_name
	from {{ source('flights_demo','aircrafts_data') }}
	where 1=1
),
seats as
(
	select *
	from {{ source('flights_demo','seats') }}
	where 1=1
),
aircraft_seats_info as
(
select 
	aircraft.aircraft_code,
	range,
	model_english_name,
	model_russian_name,
	seat_no,
	fare_conditions,
	ranges_condition,
	'{{ run_started_at.strftime ("%Y-%m-%d %H:%M:%S")}}'::timestamp as dbt_time
from aircraft
left join seats
on aircraft.aircraft_code = seats.aircraft_code
)
select *	
from aircraft_seats_info