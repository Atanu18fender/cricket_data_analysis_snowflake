-- json file format --
create or replace file format my_json_format
 type = json
 null_if = ('\\n', 'null', '')
 strip_outer_array = true
 comment = 'Json File Format with outer stip array flag true';
