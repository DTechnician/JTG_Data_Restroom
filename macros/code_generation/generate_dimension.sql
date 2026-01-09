{% macro generate_surrogate_key(fields) %} 
    md5( {% for field in fields %} coalesce(cast({{ field }} as varchar), '') || '||' {% if not loop.last %} || {% endif %} {% endfor %} ) 
{% endmacro %}

{% macro generate_dimension(
        source,
        table_name,
        natural_key,
        attributes,
        scd_type=2
    ) %}

    {# ---------------------------------------------
    Validate inputs
    ---------------------------------------------- #}
    {% if natural_key | length == 0 %}
        {{ exceptions.raise_compiler_error("generate_dimension requires at least one natural key") }}
    {% endif %}

    {% if attributes | length == 0 %}
        {{ exceptions.raise_compiler_error("generate_dimension requires at least one attribute column") }}
    {% endif %}

    {# ---------------------------------------------
    Load raw source
    ---------------------------------------------- #}
    {% set src = ref("raw_"+source+"__"+table_name) %}

    with source_data as (
        select
            {% for nk in natural_key %}
                {{ nk }}{% if not loop.last %}, {% endif %}
            {% endfor %},

            {% for col in attributes %}
                {{ col }}{% if not loop.last %}, {% endif %}
            {% endfor %},

            {{ generate_surrogate_key(natural_key) }} as natural_key_hash,
            {{ generate_surrogate_key(attributes) }} as attributes_hash,

            current_timestamp() as record_loaded_at
        from {{ src }}
    ),

    prepared as (
        select
            {{ generate_surrogate_key(['natural_key_hash'] + ['attributes_hash']) }} as {{table_name}}_sk,

            {% for nk in natural_key %}
                {{ nk }}{% if not loop.last %}, {% endif %}
            {% endfor %},

            {% for col in attributes %}
                {{ col }}{% if not loop.last %}, {% endif %}
            {% endfor %},

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

{% macro generate_navusoft_staging(
        entity_name,
        unique_key,
        fields
    ) %}

    {{ config(
        materialized='incremental',
        unique_key=unique_key
    ) }}

    with source_data as (

        select
            source_system,
            entity_name,
            load_mode,
            ingested_at,
            payload,

            {# -----------------------------
            Extract fields from payload
            ------------------------------ #}
            {% for field in fields %}
                payload:{{ field.name }}::{{ field.type }} as {{ field.name }}{% if not loop.last %}, {% endif %}
            {% endfor %},

            md5(payload::string) as payload_hash

        from  {{ source('navusoft','navusoft_raw_entities') }}
        where entity_name = '{{ entity_name }}'

        {% if is_incremental() %}
        and ingested_at >= (
            select coalesce(max(ingested_at), '1900-01-01')
            from {{ this }}
        )
        {% endif %}

    ),

    deduped as (

        select *
        from (
            select *,
                row_number() over (
                    partition by {{ unique_key }}
                    order by ingested_at desc
                ) as rn
            from source_data
        )
        where rn = 1

    )

    select *
    from deduped

{% endmacro %}
