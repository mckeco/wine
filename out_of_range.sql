-- GDD Growing degree days
with t9 as (select n.year, count(*) as gdd
			from napa_climate as n
			left join growing_season as gs
			on n.year=gs.year
	  		where n.date between gs.budding and gs.harvest
	  		group by 1
		   	order by 1),


-- days above 95 degress
	t1 as (select n.year, count(*) as temp_above_range
			from napa_climate as n
			left join growing_season as gs
			on n.year=gs.year
	  		where air_temp_max>95 and n.date between gs.budding and gs.harvest
	  		group by 1
		   	order by 1),
			
-- days below 68 degree		
	t2 as	(select n.year, count(*) as temp_below_range
			from napa_climate as n
			 left join growing_season as gs
			on n.year=gs.year
	  		where air_temp_max<68 and n.date between gs.budding and gs.harvest
	  		group by 1
			order by 1),
			
-- avg temperature
	t3 as (select n.year, round(avg(air_temp_max),2) as avg_temp
		  	from napa_climate as n
			left join growing_season as gs
			on n.year=gs.year
	  		where n.date between gs.budding and gs.harvest
		  	group by 1
		  	order by 1),
	
-- precipitation
	t4 as (select n.year, sum(precipitation)as yearly_rain
		  	from napa_climate as n
		  	group by 1
		  order by 1),
			
-- soil above 64 degress
	t5 as (select n.year, count(*) as soil_above_range
			from napa_climate as n
			left join growing_season as gs
			on n.year=gs.year
	  		where soil_temp_max>64 and n.date between gs.budding and gs.harvest
	  		group by 1
		 	order by 1),
		  
-- humidity
	t6 as (select n.year, ((sum(hum_max)+sum(hum_min)/count(n.index))/365) as avg_hum
		  	from napa_climate as n
		   	left join growing_season as gs
			on n.year=gs.year
	  		where n.date between gs.budding and gs.harvest
		  	group by 1
		  	order by 1),
			
-- radiation watts/m2
	t7 as (select n.year, sum(solar_radiation)/count(n.index) as season_rad
		  	from napa_climate as n
		   	left join growing_season as gs
			on n.year=gs.year
			where n.date between gs.budding and gs.harvest
		   	group by 1
		  	order by 1),
			
-- Evapotranspiration
	t8 as (select n.year, sum(evapotranspiration)/count(n.index) as season_eva
		  	from napa_climate as n
		   	left join growing_season as gs
			on n.year=gs.year
			where n.date between gs.budding and gs.harvest
		   	group by 1
		  	order by 1)
			
			

  
select 
n.year
, t9.gdd as gdd
, (t1.temp_above_range+t2.temp_below_range) as days_out_of_temp_range
, t5.soil_above_range as days_out_of_soil_range
, t3.avg_temp as avg_temp
, t4.yearly_rain as rain
, t6.avg_hum as humidity
, t7.season_rad as radiation
, t8.season_eva as evapotranspiration
from napa_climate as n
left join t1
on n.year=t1.year
left join t2
on n.year=t2.year
join t3
on n.year=t3.year
join t4
on n.year=t4.year
join t5
on n.year=t5.year
join t6
on n.year=t6.year
join t7
on n.year=t7.year
join t8
on n.year=t8.year
join t9
on n.year=t9.year
group by 1,  2, 3, 4, 5, 6, 7,8,9
order by 1

 
 
