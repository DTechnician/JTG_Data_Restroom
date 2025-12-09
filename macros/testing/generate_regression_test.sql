{%-macro regression_raw(raw_source, table_name,excl_col)-%}
    {%set source_table_name = table_name%}
    {%set raw_table_name = "raw_"+raw_source+"__"+table_name%}
    {%set excl_col = excl_col%}

    {%set source_cols = adapter.get_columns_in_relation(source(raw_source,source_table_name))%}
    {%set raw_cols = adapter.get_columns_in_relation(ref(raw_table_name))%}

--generate source table query
{%-set source_query%}
    select {{-'\n'-}} 
        {%-for col in source_cols -%}
            {% if col.name|lower not in excl_col%}
                {{- col.name|lower }} {%-if not loop.last %},{{-'\n'}}{%- endif %}
            {%- endif %}
        {%-endfor -%}
    {{-'\n'}}from {{source(raw_source,source_table_name)}}
{%-endset%}
--generate raw table query
{%-set raw_query%}
    select {{-'\n'-}} 
        {%-for col in raw_cols -%}
            {% if col.name|lower not in excl_col%}
                {{- col.name|lower }} {%-if not loop.last %},{{-'\n'}}{%- endif %}
            {%- endif %}
        {%-endfor -%}
    {{-'\n'}}from {{ref(raw_table_name)}} 
{%-endset%}

 {{-audit_helper.compare_queries(
     a_query=source_query,
     b_query=raw_query)
 -}}


{%-endmacro-%}