create or replace task CRICKET.RAW.LOAD_TO_CLEAN_DELIVERY
	warehouse=COMPUTE_WH
	after CRICKET.RAW.LOAD_TO_CLEAN_PLAYER
	when system$stream_has_data('cricket.raw.for_delivery_stream')
	as insert into cricket.clean.delivery_clean_tbl
select raw.info:match_type_number::int as match_type_number,
   i.value:team::text as Team_Name,
   o.value:over::int+1 as over_number, -- since over starts as 0 we are adding +1 to start it from 1
   d.value:bowler::text as bowler,
   d.value:batter::text as batter,
   d.value:non_striker::text as non_striker,
   d.value:runs.batter::text as run,
   d.value:runs:extras::text as extra,
   d.value:runs:total::text as total_run,
   e.key::text as extra_type,
   e.value::number as extra_runs,
   w.value:player_out::text as player_out,
   w.value:kind::text as player_out_kind,
   w.value:fielders::text as fielders
   from cricket.raw.for_delivery_stream raw,
   lateral flatten(input => raw.innings) i,
   lateral flatten(input => i.value:overs) o,
   lateral flatten(input => o.value:deliveries) d,
   lateral flatten(input => d.value:extras, outer=>True) e,
   lateral flatten(input => d.value:wickets, outer=>True) w;
