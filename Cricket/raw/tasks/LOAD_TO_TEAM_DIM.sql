create or replace task CRICKET.RAW.LOAD_TO_TEAM_DIM
	warehouse=COMPUTE_WH
	after CRICKET.RAW.LOAD_TO_CLEAN_DELIVERY
	as insert into cricket.public.team_dim (team_name)
select distinct team_name from
(
 select first_team as team_name from cricket.clean.match_detail_clean
 union all
 select second_team as team_name from cricket.clean.match_detail_clean
);
