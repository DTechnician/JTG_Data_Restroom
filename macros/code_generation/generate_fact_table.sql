{% macro generate_fact_table(
    source_name,
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
        {{ generate_surrogate_key(natural_key) }} as fact_sk,

        {%- for col in natural_key -%}
            {{ col }}{% if not loop.last %}, {% endif %}
        {%- endfor -%},

        {%- for f in fact_fields -%}
            {{ f }}{% if not loop.last %} , {% endif %}
        {%- endfor -%},

        {{ updated_at_column }}

    from {{ src }}
)

{#-------------------------------------------
   Dimension lookups
-------------------------------------------#}
{% for dim_name, mapping in dimension_lookups.items() %}

, {{ dim_name }}_lkp as (
    select
        {{ mapping.dim_sk }} as {{ dim_name }}_sk,
        {%- for key in mapping.dim_keys -%}
            {{ key }}{% if not loop.last %},{% endif %}
        {%- endfor %}
    from {{ ref(mapping.dim_model) }}
    where is_current = true
)

{% endfor %}

, final as (

    select
        raw_fact.fact_sk

        {# Dimension FKs #}
        {%- for dim_name, mapping in dimension_lookups.items() -%}
            , {{ dim_name }}_lkp.{{ dim_name }}_sk
        {%- endfor -%}

        {# Natural Keys #}
        {%- for col in natural_key -%}
            ,  raw_fact.{{ col }}
        {%- endfor -%}

        {# Fact fields #}
        {%- for f in fact_fields -%}
            , raw_fact.{{ f }}
        {%- endfor -%}

        {# Derived fields #}
        {%- for alias, expression in derived_fields.items() -%}
            , {{ expression }} as {{ alias }}
        {%- endfor -%}

        , raw_fact.{{ updated_at_column }}

    from raw_fact

    {# Joins for all dimensions #}
    {%- for dim_name, mapping in dimension_lookups.items() -%}
    left join {{ dim_name }}_lkp
        on
        {% for i in range(mapping.src_keys | length) %}
            {%- if i > 0 -%} AND {% endif -%}
            raw_fact.{{ mapping.src_keys[i] }} = {{ dim_name }}_lkp.{{ mapping.dim_keys[i] }}
        {% endfor %}
    {%- endfor -%}

)

select *
from final

{% if is_incremental() %}
where {{ updated_at_column }} > (select coalesce(max({{ updated_at_column }}), '1900-01-01') from {{ this }})
{% endif %}

{% endmacro %}