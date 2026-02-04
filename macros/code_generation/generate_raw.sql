{% macro generate_staging_model(
    source_name,
    table_name,
    column_expressions,
    incremental_filter_column,
    unique_key
) %}

{{ config(
    materialized='incremental',
    unique_key=unique_key
) }}

with raw as (
    select *
    from {{ source(source_name, table_name) }}
)

select
    {{ column_expressions | join(",\n    ") }}
from raw

{% if is_incremental() %}
where {{ incremental_filter_column }} >= (
    select max({{ incremental_filter_column }}) from {{ this }}
)
{% endif %}

<<<<<<< HEAD
{% endmacro %}
=======
{% endmacro %}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
