create or replace TABLE CRICKET.PUBLIC.MATCH_TYPE_DIM (
	MATCH_TYPE_ID NUMBER(38,0) NOT NULL autoincrement start 1 increment 1 noorder,
	MATCH_TYPE VARCHAR(16777216) NOT NULL,
	primary key (MATCH_TYPE_ID)
);
