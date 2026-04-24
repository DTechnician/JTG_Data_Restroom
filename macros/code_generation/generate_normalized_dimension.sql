
{%- macro vehicle_map_name(name_col) -%}
    -- Normalize a free-text vehicle name into a stable natural key
    -- Example: "Truck abc-123 (Unit)" -> "ABC123"
    upper(
      regexp_replace(
        regexp_substr(upper({{ name_col }}), '[A-Z]*-?[0-9]+'),
        '[^A-Z0-9]',
        ''
      )
    )
{%- endmacro -%}


{% macro agg_concat_distinct(expr, sep=', ') %}
  {%- if target.type in ['snowflake'] -%}
    listagg(distinct {{ expr }}, '{{ sep }}') within group (order by {{ expr }})
  {%- elif target.type in ['bigquery'] -%}
    array_to_string(array_agg(distinct {{ expr }}), '{{ sep }}')
  {%- elif target.type in ['databricks', 'spark'] -%}
    concat_ws('{{ sep }}', collect_set({{ expr }}))
  {%- elif target.type in ['postgres'] -%}
    string_agg(distinct {{ expr }}, '{{ sep }}')
  {%- else -%}
    -- Fallback (may not de-dup)
    string_agg({{ expr }}, '{{ sep }}')
  {%- endif -%}
{% endmacro %}
