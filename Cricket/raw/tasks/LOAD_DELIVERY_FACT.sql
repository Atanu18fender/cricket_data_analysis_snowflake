create or replace task CRICKET.RAW.LOAD_DELIVERY_FACT
	warehouse=COMPUTE_WH
	after CRICKET.RAW.LOAD_MATCH_FACT
	as INSERT INTO cricket.public.delivery_fact
select a.* from(
SELECT 
    d.match_type_number AS match_id,
    td.team_id AS team_id,  -- batting team
    
    -- Correct bowler_id by joining on opponent team
    blr.player_id AS bowler_id,

    -- Correct batter_id using team_id + player_name
    btr.player_id AS batter_id,

    -- Correct non-striker_id
    nstr.player_id AS non_striker_id,

    d.over_number AS over,
    d.run AS runs,
    COALESCE(d.extra_runs, 0) AS extra_runs,
    COALESCE(d.extra_type, 'None') AS extra_type,
    COALESCE(d.player_out, 'None') AS player_out,
    COALESCE(d.player_out_kind, 'None') AS player_out_kind

FROM cricket.clean.delivery_clean_tbl d
-- Get batting team_id
JOIN cricket.public.team_dim td 
    ON d.team_name = td.team_name
-- Match details (for match_id and team matchup)
JOIN cricket.clean.match_detail_clean mdc 
    ON d.match_type_number = mdc.match_type_number
-- Opponent team: if batting team is first, then bowler must be from second, and vice versa
JOIN cricket.public.team_dim opp_td 
    ON (
        mdc.first_team = d.team_name AND mdc.second_team = opp_td.team_name
        OR
        mdc.second_team = d.team_name AND mdc.first_team = opp_td.team_name
    )
-- Join batter with correct team
JOIN cricket.public.player_dim btr 
    ON d.batter = btr.player_name AND td.team_id = btr.team_id
-- Join non-striker with correct team
JOIN cricket.public.player_dim nstr 
    ON d.non_striker = nstr.player_name AND td.team_id = nstr.team_id
-- Join bowler with **opponent** team
JOIN cricket.public.player_dim blr 
    ON d.bowler = blr.player_name AND opp_td.team_id = blr.team_id) a
    left join cricket.public.delivery_fact b on a.match_id = b.match_id
    where b.match_id is null;
