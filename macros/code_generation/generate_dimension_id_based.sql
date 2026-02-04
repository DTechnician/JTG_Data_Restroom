<<<<<<< HEAD
{% macro generate_dimension_id(
    source,
    table_name,
    natural_key,
    attributes,
    scd_type = 2
) %}

{% set src = ref("raw_" ~ source ~ "__" ~ table_name) %}

with source_data as (

    select
        {# -----------------------------
           Dimension ID (natural / composite)
        ------------------------------ #}
        {% if natural_key | length == 1 %}
            {{ natural_key[0] }} as {{ table_name }}_id
        {% else %}
            concat(
                {%- for col in natural_key -%}
                    cast({{ col }} as varchar)
                    {% if not loop.last %}, '|', {% endif %}
                {%- endfor -%}
            ) as {{ table_name }}_id
        {% endif %},

        {%- for col in attributes -%}
            {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        {{ generate_surrogate_key(attributes) }} as attributes_hash,
        current_timestamp() as record_loaded_at

    from {{ src }}
),

prepared as (

    select
        {{ table_name }}_id,

        {%- for col in attributes -%}
            {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        attributes_hash,
        record_loaded_at,

        {% if scd_type == 2 %}
            record_loaded_at as valid_from,
            null as valid_to,
            true as is_current
        {% else %}
            null as valid_from,
            null as valid_to,
            null as is_current
        {% endif %}

    from source_data
)

select *
from prepared

{% if is_incremental() and scd_type == 2 %}
where attributes_hash not in (
    select attributes_hash
    from {{ this }}
    where is_current = true
)
{% endif %}

{% endmacro %}
=======
{% macro generate_dimension_id(
    source,
    table_name,
    natural_key,
    attributes,
    scd_type = 2
) %}

{% set src = ref("raw_" ~ source ~ "__" ~ table_name) %}

with source_data as (

    select
        {# -----------------------------
           Dimension ID (natural / composite)
        ------------------------------ #}
        {% if natural_key | length == 1 %}
            {{ natural_key[0] }} as {{ table_name }}_id
        {% else %}
            concat(
                {%- for col in natural_key -%}
                    cast({{ col }} as varchar)
                    {% if not loop.last %}, '|', {% endif %}
                {%- endfor -%}
            ) as {{ table_name }}_id
        {% endif %},

        {%- for col in attributes -%}
            {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        {{ generate_surrogate_key(attributes) }} as attributes_hash,
        current_timestamp() as record_loaded_at

    from {{ src }}
),

prepared as (

    select
        {{ table_name }}_id,

        {%- for col in attributes -%}
            {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        attributes_hash,
        record_loaded_at,

        {% if scd_type == 2 %}
            record_loaded_at as valid_from,
            null as valid_to,
            true as is_current
        {% else %}
            null as valid_from,
            null as valid_to,
            null as is_current
        {% endif %}

    from source_data
)

select *
from prepared

{% if is_incremental() and scd_type == 2 %}
where attributes_hash not in (
    select attributes_hash
    from {{ this }}
    where is_current = true
)
{% endif %}

{% endmacro %}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
