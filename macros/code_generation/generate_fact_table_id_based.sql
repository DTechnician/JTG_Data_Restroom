<<<<<<< HEAD
{% macro generate_fact_table_id(
    table_name,
    natural_key,
    dimension_lookups,
    fact_fields,
    derived_fields = {},
    updated_at_column = 'updated_at'
) %}

{% set src = ref(table_name) %}

with raw_fact as (

    select
        {# -----------------------------
           Fact ID (natural / composite)
        ------------------------------ #}
        {% if natural_key | length == 1 %}
            {{ natural_key[0] }} as fact_id
        {% else %}
            concat(
                {%- for col in natural_key -%}
                    cast({{ col }} as varchar)
                    {% if not loop.last %}, '|', {% endif %}
                {%- endfor -%}
            ) as fact_id
        {% endif %},

        {%- for col in natural_key -%}
            {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        {%- for f in fact_fields -%}
            {{ f }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        {{ updated_at_column }}

    from {{ src }}
)

{#-------------------------------------------
   Dimension lookups (ID-based)
-------------------------------------------#}
{% for dim_name, mapping in dimension_lookups.items() %}

, {{ dim_name }}_lkp as (
    select
        {{ mapping.dim_id }} as {{ dim_name }}_id
    from {{ ref(mapping.dim_model) }}
    where is_current = true
)

{% endfor %}

, final as (

    select
        raw_fact.fact_id

        {%- for dim_name, mapping in dimension_lookups.items() -%}
            , {{ dim_name }}_lkp.{{ dim_name }}_id
        {%- endfor -%}

        {%- for f in fact_fields -%}
            , raw_fact.{{ f }}
        {%- endfor -%}

        {%- for alias, expression in derived_fields.items() -%}
            , {{ expression }} as {{ alias }}
        {%- endfor -%}

        , raw_fact.{{ updated_at_column }}

    from raw_fact

    {%- for dim_name, mapping in dimension_lookups.items() -%}
    left join {{ dim_name }}_lkp
        on
        {%- for i in range(mapping.src_keys | length) -%}
            {%- if i > 0 -%} AND {% endif -%}
            raw_fact.{{ mapping.src_keys[i] }}
                = {{ dim_name }}_lkp.{{ mapping.dim_keys[i] }}
        {%- endfor -%}
    {%- endfor -%}

)

select *
from final

{% if is_incremental() %}
where {{ updated_at_column }} >
    (select coalesce(max({{ updated_at_column }}), '1900-01-01') from {{ this }})
{% endif %}

{% endmacro %}
=======
{% macro generate_fact_table_id(
    table_name,
    natural_key,
    dimension_lookups,
    fact_fields,
    derived_fields = {},
    updated_at_column = 'updated_at'
) %}

{% set src = ref(table_name) %}

with raw_fact as (

    select
        {# -----------------------------
           Fact ID (natural / composite)
        ------------------------------ #}
        {% if natural_key | length == 1 %}
            {{ natural_key[0] }} as fact_id
        {% else %}
            concat(
                {%- for col in natural_key -%}
                    cast({{ col }} as varchar)
                    {% if not loop.last %}, '|', {% endif %}
                {%- endfor -%}
            ) as fact_id
        {% endif %},

        {%- for col in natural_key -%}
            {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        {%- for f in fact_fields -%}
            {{ f }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        {{ updated_at_column }}

    from {{ src }}
)

{#-------------------------------------------
   Dimension lookups (ID-based)
-------------------------------------------#}
{% for dim_name, mapping in dimension_lookups.items() %}

, {{ dim_name }}_lkp as (
    select
        {{ mapping.dim_id }} as {{ dim_name }}_id
    from {{ ref(mapping.dim_model) }}
    where is_current = true
)

{% endfor %}

, final as (

    select
        raw_fact.fact_id

        {%- for dim_name, mapping in dimension_lookups.items() -%}
            , {{ dim_name }}_lkp.{{ dim_name }}_id
        {%- endfor -%}

        {%- for f in fact_fields -%}
            , raw_fact.{{ f }}
        {%- endfor -%}

        {%- for alias, expression in derived_fields.items() -%}
            , {{ expression }} as {{ alias }}
        {%- endfor -%}

        , raw_fact.{{ updated_at_column }}

    from raw_fact

    {%- for dim_name, mapping in dimension_lookups.items() -%}
    left join {{ dim_name }}_lkp
        on
        {%- for i in range(mapping.src_keys | length) -%}
            {%- if i > 0 -%} AND {% endif -%}
            raw_fact.{{ mapping.src_keys[i] }}
                = {{ dim_name }}_lkp.{{ mapping.dim_keys[i] }}
        {%- endfor -%}
    {%- endfor -%}

)

select *
from final

{% if is_incremental() %}
where {{ updated_at_column }} >
    (select coalesce(max({{ updated_at_column }}), '1900-01-01') from {{ this }})
{% endif %}

{% endmacro %}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
