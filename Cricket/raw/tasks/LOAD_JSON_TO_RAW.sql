create or replace task CRICKET.RAW.LOAD_JSON_TO_RAW
	warehouse=COMPUTE_WH
	schedule='10 minute'
	as copy into cricket.raw.match_raw_tbl from 
    (
    select 
        t.$1:meta::object as meta, 
        t.$1:info::variant as info, 
        t.$1:innings::array as innings, 
        --
        metadata$filename,
        metadata$file_row_number,
        metadata$file_content_key,
        metadata$file_last_modified
    from @cricket.land.my_stg/cricket/json (file_format => 'cricket.land.my_json_format') t
    )
    on_error = continue;
