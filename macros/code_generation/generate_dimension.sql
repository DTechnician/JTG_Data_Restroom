{% macro generate_surrogate_key(fields) %} 
    md5( {% for field in fields %} coalesce(cast({{ field }} as varchar), '') || '||' {% if not loop.last %} || {% endif %} {% endfor %} ) 
{% endmacro %}

{% macro ts_now() %}
    current_timestamp()::{{ var('timestamp_type', 'timestamp_ltz') }}
{% endmacro %}

{% macro null_ts() %}
    cast(null as {{ var('timestamp_type', 'timestamp_ltz') }})
{% endmacro %}


{% macro generate_dimension(
    source,
    table_name,
    natural_key,
    attributes,
    scd_type=2
) %}

{% if natural_key | length == 0 %}
    {{ exceptions.raise_compiler_error("generate_dimension requires at least one natural key") }}
{% endif %}

{% if attributes | length == 0 %}
    {{ exceptions.raise_compiler_error("generate_dimension requires at least one attribute column") }}
{% endif %}

{% set src = ref("raw_" ~ source ~ "__" ~ table_name) %}

{# -----------------------------------------
   Choose change timestamp per source
----------------------------------------- #}
{% if source == 'samsara' %}
    {% set change_ts = '_fivetran_synced' %}
{% elif source == 'navusoft' %}
    {% set change_ts = 'ingested_at' %}
{% else %}
    {% set change_ts = 'record_loaded_at' %}
{% endif %}

{% if not is_incremental() and scd_type == 2 %}

-- =====================================================
-- FULL REFRESH MODE (Rebuild SCD2 History)
-- =====================================================

with ordered as (

    select
        {% for nk in natural_key %} {{ nk }}, {% endfor %}
        {% for col in attributes %} {{ col }}, {% endfor %}

        {{ change_ts }}::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_from,

        lead({{ change_ts }}) over (
            partition by {% for nk in natural_key %} {{ nk }}{% if not loop.last %}, {% endif %}{% endfor %}
            order by {{ change_ts }} asc
        )::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_to

    from {{ src }}

),

final as (

    select
        {{ generate_surrogate_key([generate_surrogate_key(natural_key), generate_surrogate_key(attributes)]) }} as {{ table_name }}_sk,

        {% for nk in natural_key %} {{ nk }}, {% endfor %}
        {% for col in attributes %} {{ col }}, {% endfor %}

        {{ generate_surrogate_key(attributes) }} as attributes_hash,

        valid_from,
        valid_to,
        {{ ts_now() }} as record_loaded_at,
        case when valid_to is null then true else false end as is_current


    from ordered

)

select * from final

{% else %}

-- =====================================================
-- INCREMENTAL MODE (SCD2)
-- =====================================================

with source_data as (

    select *
    from (
        select
            {% for nk in natural_key %} {{ nk }}, {% endfor %}
            {% for col in attributes %} {{ col }}, {% endfor %}

            {{ generate_surrogate_key(natural_key) }} as natural_key_hash,
            {{ generate_surrogate_key(attributes) }} as attributes_hash,

            {{ ts_now() }} as record_loaded_at,

            row_number() over (
                partition by {% for nk in natural_key %} {{ nk }}{% if not loop.last %}, {% endif %}{% endfor %}
                order by {{ change_ts }} desc
            ) as rn
        from {{ src }}
    ) t
    where rn = 1
)

, prepared as (

    select
        {{ generate_surrogate_key(['natural_key_hash', 'attributes_hash']) }} as {{ table_name }}_sk,

        {% for nk in natural_key %} {{ nk }}, {% endfor %}
        {% for col in attributes %} {{ col }}, {% endfor %}

        attributes_hash,
        record_loaded_at::{{ var('timestamp_type', 'timestamp_ltz') }} as record_loaded_at,
        record_loaded_at::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_from,
        {{ null_ts() }} as valid_to,
        true as is_current
    from source_data
)

, current_dim as (

    select
        {{ table_name }}_sk,
        {% for nk in natural_key %} {{ nk }}, {% endfor %}
        {% for col in attributes %} {{ col }}, {% endfor %}

        attributes_hash as curr_attributes_hash,

        record_loaded_at::{{ var('timestamp_type', 'timestamp_ltz') }} as record_loaded_at,
        valid_from::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_from,
        valid_to::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_to,

        is_current
    from {{ this }}
    where is_current = true
)

, expired as (

    select
        curr.{{ table_name }}_sk,
        {% for nk in natural_key %} curr.{{ nk }}, {% endfor %}
        {% for col in attributes %} curr.{{ col }}, {% endfor %}

        curr.curr_attributes_hash as attributes_hash,
        curr.record_loaded_at,
        curr.valid_from,
        {{ ts_now() }} as valid_to,
        false as is_current
    from current_dim curr
    join prepared src
      on {% for nk in natural_key %} curr.{{ nk }} = src.{{ nk }}{% if not loop.last %} AND {% endif %}{% endfor %}
    where curr.curr_attributes_hash != src.attributes_hash
)

, prepared_new as (

    select *
    from prepared p
    where not exists (
        select 1
        from {{ this }} hist
        where hist.is_current = true
          and {% for nk in natural_key %} hist.{{ nk }} = p.{{ nk }}{% if not loop.last %} AND {% endif %}{% endfor %}
          and hist.attributes_hash = p.attributes_hash
    )
)

select * from prepared_new
union all
select * from expired

{% endif %}

{% endmacro %}


--------------------------------------------------------


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