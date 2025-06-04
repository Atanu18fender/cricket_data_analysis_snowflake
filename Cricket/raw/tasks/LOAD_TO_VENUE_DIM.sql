create or replace task CRICKET.RAW.LOAD_TO_VENUE_DIM
	warehouse=COMPUTE_WH
	after CRICKET.RAW.LOAD_TO_CLEAN_DELIVERY
	as insert into cricket.public.venue_dim (venue_name,city)
select venue,
case 
when city is null then 'NA'
else city
end as city
from cricket.clean.match_detail_clean
group by venue,city;
