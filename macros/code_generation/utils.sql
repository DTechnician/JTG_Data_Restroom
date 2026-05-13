{%-macro ms_to_datetime(ms_field)-%}
    case
        when {{ms_field}} is null then null --null ms data
        when {{ms_field}} >= 32503680000000 then null --invalid ms data 
        when {{ms_field}} < 0 then null --invalid ms data
        else to_timestamp({{ms_field}} / 1000) --valid values
    end
{%-endmacro-%}