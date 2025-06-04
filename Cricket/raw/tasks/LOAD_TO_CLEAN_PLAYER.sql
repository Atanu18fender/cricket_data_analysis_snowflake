create or replace task CRICKET.RAW.LOAD_TO_CLEAN_PLAYER
	warehouse=COMPUTE_WH
	after CRICKET.RAW.LOAD_TO_CLEAN_MATCH
	when system$stream_has_data('cricket.raw.for_player_stream')
	as insert into cricket.clean.player_table_clean
select 
   raw.info:match_type_number::int as match_type_number,
   p.key::text as team,
   player.value::text as player_name,
   raw.stg_file_name,
   raw.stg_file_hashkey,
   raw.stg_file_row_number
   from cricket.raw.for_player_stream as raw,
   lateral flatten(input=> raw.info:players) as p,
   lateral flatten(input=> p.value) as player;
