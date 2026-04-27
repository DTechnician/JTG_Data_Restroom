{% macro generate_surrogate_key(fields) %} 
    md5( {% for field in fields %} coalesce(cast({{ field }} as varchar), '') || '||' {% if not loop.last %} || {% endif %} {% endfor %} ) 
{% endmacro %}

{% macro ts_now() %}
    current_timestamp()::{{ var('timestamp_type', 'timestamp_ltz') }}
{% endmacro %}

{% macro null_ts() %}
    cast(null as {{ var('timestamp_type', 'timestamp_ltz') }})
{% endmacro %}


{# 
generate_dimension macro parameters:

source              : source system name
table_name          : dimension table name
natural_key         : list[str]
attributes     : list[str] (raw attributes)
derived_attributes  : list[dict] [{name, expr}]
foreign_keys        : list[dict] FK config
scd_type            : currently supports only type 2
#}

{%- macro generate_dimension(
    source,
    table_name,
    sk_name,
    natural_key,             
    attributes,         
    derived_attributes=[],   
    foreign_keys=[],         
    scd_type=2,
    dedupe_strategy='latest'
) -%}

{# ---------------- Validations ---------------- #}
    {%- if natural_key | length == 0 -%}
        {{ exceptions.raise_compiler_error("generate_dimension requires at least one natural key") }}
    {%- endif -%}

    {%- set has_any_attr = (attributes | length) + (derived_attributes | length) + (foreign_keys | length) -%}
    {%- if has_any_attr == 0 -%}
        {{ exceptions.raise_compiler_error("generate_dimension requires at least one attribute (base, derived, or FK)") }}
    {%- endif -%}

    {# ---------------- Inputs & Derived Lists ---------------- #}
    {%- set src = ref("raw_" ~ source ~ "__" ~ table_name) -%}
    {%- set _sk = (sk_name | default(table_name ~ '_sk', true)) -%}

    {# derive names from structures #}
    {%- set derived_names = derived_attributes | map(attribute='name') | list -%}
    {%- set fk_names = foreign_keys | map(attribute='name') | list -%}
    {%- set all_attributes = (attributes + derived_names + fk_names) -%}


    {# -----------------------------------------
    Choose change timestamp per source
    ----------------------------------------- #}
    {%- if source == 'samsara' -%}
        {%- set change_ts = '_fivetran_synced' -%}
    {%- elif source == 'navusoft' -%}
        {%- set change_ts = 'ingested_at' -%}
    {%- else -%}
        {%- set change_ts = 'record_loaded_at' -%}
    {%- endif -%}

    {# -----------------------------------------
    CTE: Raw + Derived attributes from source
    ----------------------------------------- #}
    with 

    src_raw as (
        {%- set ns = namespace(cols=[]) -%}
        {%- for nk in natural_key -%}{%- set ns.cols = ns.cols + [nk] -%}{%- endfor -%}
        {%- for col in attributes -%}{%- set ns.cols = ns.cols + [col] -%}{%- endfor -%}
        {%- for d in derived_attributes -%}{%- set ns.cols = ns.cols + [d.expr ~ ' as ' ~ d.name] -%}{%- endfor -%}
        {%- set ns.cols = ns.cols + [change_ts ~ '::' ~ var('timestamp_type', 'timestamp_ltz') ~ ' as _change_ts'] -%}

        select {{ ns.cols | join(',') }} from {{ src }}

    ),


    {# -----------------------------------------------
    NEW: Deduplicate raw rows per NK
    ----------------------------------------------- #}
    deduped_src_raw as (
        select *
        from (
            select
                *,
                row_number() over (
                    partition by {{ natural_key | join(', ') }}
                    order by 
                        case 
                            when '{{ dedupe_strategy }}' = 'latest' 
                                then _change_ts 
                        end desc
                ) as rn
            from src_raw
        )
        where rn = 1
    ),


    {# -----------------------------------------
    CTE: Attach FK columns via joins to other dimensions
    foreign_keys item schema:
    {
        name: 'customer_sk',       -- alias to create in this dimension
        dim_model: 'dim_customer', -- dbt model name to ref
        join_on: [                 -- list of {src: 'src_col', dim: 'dim_nk_col'}
        {src: 'customer_id', dim: 'customer_id'}
        ],
        dim_sk: 'customer_sk',     -- optional; defaults to dim_model ~ '_sk'
        join_type: 'left'          -- optional; 'left'|'inner' (default 'left')
    }
    ----------------------------------------- #}
    with_fks as (
        select
            r.*{% if foreign_keys | length > 0 %},{% endif %}
            {% for fk in foreign_keys %}
                {%- set alias = "d" ~ loop.index -%}
                {%- set dim_sk = fk.dim_sk if fk.dim_sk is defined else (fk.dim_model ~ "_sk") -%}
                {{ alias }}.{{ dim_sk }} as {{ fk.name }}{{ "," if not loop.last else "" }}
            {% endfor %}
        from deduped_src_raw r
        {% for fk in foreign_keys %}
            {%- set alias = "d" ~ loop.index -%}
            {{ (fk.join_type | default('left')) | upper }} join {{ ref(fk.dim_model) }} {{ alias }}
            on {{ alias }}.is_current = true
            {% if fk.join_on is not defined or fk.join_on | length == 0 %}
                {{ exceptions.raise_compiler_error("Each foreign_keys item must define a non-empty join_on list with {src, dim}") }}
            {% endif %}
            {% for cond in fk.join_on %}
            and r.{{ cond.src }} = {{ alias }}.{{ cond.dim }}
            {% endfor %}
        {% endfor %}
    )

    {# -----------------------------------------
    FULL REFRESH MODE (Rebuild SCD2 History)
    ----------------------------------------- #}
    {%- if not is_incremental() and scd_type == 2 -%}

    , ordered as (
        select
            {% for nk in natural_key %} {{ nk }}, {% endfor %}
            {% for col in attributes %} {{ col }}, {% endfor %}
            {% for nm in derived_names %} {{ nm }}, {% endfor %}
            {% for fkcol in fk_names %} {{ fkcol }}, {% endfor %}

            _change_ts as valid_from,
            lead(_change_ts) over (
                partition by {% for nk in natural_key %} {{ nk }}{% if not loop.last %}, {% endif %}{% endfor %}
                order by _change_ts asc
            ) as valid_to
        from with_fks
    )

    , final as (
        select
            {{ generate_surrogate_key([ generate_surrogate_key(natural_key), generate_surrogate_key(all_attributes) ]) }} as {{_sk}},

            {% for nk in natural_key %} {{ nk }}, {% endfor %}
            {% for col in attributes %} {{ col }}, {% endfor %}
            {% for nm in derived_names %} {{ nm }}, {% endfor %}
            {% for fkcol in fk_names %} {{ fkcol }}, {% endfor %}

            {{ generate_surrogate_key(all_attributes) }} as attributes_hash,

            valid_from::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_from,
            valid_to::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_to,

            {{ ts_now() }} as record_loaded_at,
            case when valid_to is null then true else false end as is_current
        from ordered
    )

    select * from final

    {# -----------------------------------------
    INCREMENTAL MODE (SCD2)
    ----------------------------------------- #}
    {% else %}

    , source_data as (
        select *
        from (
            select
                {% for nk in natural_key %} {{ nk }}, {% endfor %}
                {% for col in attributes %} {{ col }}, {% endfor %}
                {% for nm in derived_names %} {{ nm }}, {% endfor %}
                {% for fkcol in fk_names %} {{ fkcol }}, {% endfor %}

                {{ generate_surrogate_key(natural_key) }} as natural_key_hash,
                {{ generate_surrogate_key(all_attributes) }} as attributes_hash,

                {{ ts_now() }} as record_loaded_at,

                row_number() over (
                    partition by {% for nk in natural_key %} {{ nk }}{% if not loop.last %}, {% endif %}{% endfor %}
                    order by _change_ts desc
                ) as rn
            from with_fks
        ) t
        where rn = 1
    )

    , prepared as (
        select
            {{ generate_surrogate_key(['natural_key_hash', 'attributes_hash']) }} as {{_sk}},

            {% for nk in natural_key %} {{ nk }}, {% endfor %}
            {% for col in attributes %} {{ col }}, {% endfor %}
            {% for nm in derived_names %} {{ nm }}, {% endfor %}
            {% for fkcol in fk_names %} {{ fkcol }}, {% endfor %}

            attributes_hash,
            record_loaded_at::{{ var('timestamp_type', 'timestamp_ltz') }} as record_loaded_at,
            record_loaded_at::{{ var('timestamp_type', 'timestamp_ltz') }} as valid_from,
            {{ null_ts() }} as valid_to,
            true as is_current
        from source_data
    )

    , current_dim as (
        select
            {{_sk}},

            {% for nk in natural_key %} {{ nk }}, {% endfor %}
            {% for col in attributes %} {{ col }}, {% endfor %}
            {% for nm in derived_names %} {{ nm }}, {% endfor %}
            {% for fkcol in fk_names %} {{ fkcol }}, {% endfor %}

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
            curr.{{_sk}},

            {% for nk in natural_key %} curr.{{ nk }}, {% endfor %}
            {% for col in attributes %} curr.{{ col }}, {% endfor %}
            {% for nm in derived_names %} curr.{{ nm }}, {% endfor %}
            {% for fkcol in fk_names %} curr.{{ fkcol }}, {% endfor %}

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