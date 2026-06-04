{%-macro ms_to_datetime(ms_field)-%}
    case
        when {{ms_field}} is null then null --null ms data
        when {{ms_field}} >= 32503680000000 then null --invalid ms data 
        when {{ms_field}} < 0 then null --invalid ms data
        else to_timestamp({{ms_field}} / 1000) --valid values
    end
{%-endmacro-%}

{%-macro part_last_name()-%}
    case 
        -- with suffix → adjust index
        when p[n-1] in ('JR','SR','II','III','IV') then
            case
                -- DE LOS / DE LA / DE LAS
                when p[n-3] = 'DE' and p[n-2] in ('LOS','LA','LAS') then
                    concat(p[n-3], ' ', p[n-2], ' ', p[n-1-1])

                -- DEL
                when p[n-2] = 'DEL' then
                    concat(p[n-2], ' ', p[n-3])

                -- DE
                when p[n-2] = 'DE' then
                    concat(p[n-2], ' ', p[n-3])

                else
                    p[n-2]
            end

        -- no suffix
        else
            case
                -- ✅ DE LOS / DE LA / DE LAS
                when p[n-3] = 'DE' and p[n-2] in ('LOS','LA','LAS') then
                    concat(p[n-3], ' ', p[n-2], ' ', p[n-1])

                -- ✅ DEL
                when p[n-2] = 'DEL' then
                    concat(p[n-2], ' ', p[n-1])

                -- ✅ DE
                when p[n-2] = 'DE' then
                    concat(p[n-2], ' ', p[n-1])

                else
                    p[n-1]
            end
    end
{%-endmacro-%}

{%-macro part_suffix()-%}
    case 
        when p[array_size(p)-1] in ('JR','SR','II','III','IV') 
        then p[array_size(p)-1]
    end
{%-endmacro-%}

{%-macro clean_name(source)-%}
    {%-if source == 'samsara'-%}
        {%-set driver_name = 'name'%}
    {%-elif source == 'navusoft'-%}
        {%-set driver_name = 'driver_name'%}
    {%-endif-%}
    upper(
                trim(
                    regexp_replace(
                        regexp_replace(upper({{driver_name}}), '[^A-Z0-9\\s]', ''),
                        '\\s+',
                        ' '
                    )
                )
            ) 
{%-endmacro-%}


{% macro clean_ms(column_name) %}
    CASE
        WHEN {{ column_name }} IS NULL THEN NULL
        WHEN {{ column_name }} >= 32503680000000 THEN NULL
        WHEN {{ column_name }} < 0 THEN NULL
        ELSE {{ column_name }}
    END
{% endmacro %}
