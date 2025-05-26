create or replace TABLE CRICKET.PUBLIC.TEAM_DIM (
	TEAM_ID NUMBER(38,0) NOT NULL autoincrement start 1 increment 1 noorder,
	TEAM_NAME VARCHAR(16777216) NOT NULL,
	primary key (TEAM_ID)
);
