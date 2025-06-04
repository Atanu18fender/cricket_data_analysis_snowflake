create or replace task CRICKET.RAW.LOAD_TO_PLAYER_DIM
	warehouse=COMPUTE_WH
	after CRICKET.RAW.LOAD_TO_CLEAN_DELIVERY
	as insert into cricket.public.player_dim (team_id,player_name)
select t.team_id,t.team_name,p.player_name
from cricket.clean.player_table_clean p join cricket.public.team_dim t
on p.team = t.team_name
group by
t.team_id,
t.team_name,
p.player_name;
