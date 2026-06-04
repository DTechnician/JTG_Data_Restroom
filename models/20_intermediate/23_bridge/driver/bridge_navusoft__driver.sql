{{ config(
    materialized = 'table',
    tags = ['bridge'],
    unique_key = ['navusoft_driver_id', 'navusoft_driver_name', 'driver_sk', 'valid_from']
) }}

with navusoft_raw as (

    select distinct
        cast(navusoft_driver_id   as string) as navusoft_driver_id,
        cast(navusoft_driver_name as string) as navusoft_driver_name,
        driver_map_name

    from {{ ref('raw_prep__driver') }}
    where navusoft_driver_id is not null
      and driver_map_name is not null

),

dim as (

    select
        driver_sk,
        driver_map_name,
        valid_from,
        valid_to,
        is_current,
        record_loaded_at
    from {{ ref('dim_driver') }}
    where driver_map_name is not null

)

select
    d.driver_sk,
    r.driver_map_name,
    r.navusoft_driver_id,
    r.navusoft_driver_name,
    d.valid_from,
    d.valid_to,
    d.is_current,
    d.record_loaded_at,

    -- ✅ deterministic hash (same pattern as vehicle)
    md5(
        coalesce(d.driver_sk,'') || '|' ||
        coalesce(r.navusoft_driver_id,'') || '|' ||
        coalesce(r.navusoft_driver_name,'') || '|' ||
        coalesce(to_varchar(d.valid_from),'')
    ) as bridge_row_hash,

    current_timestamp()::timestamp_ltz as created_at,
    current_timestamp()::timestamp_ltz as updated_at

from navusoft_raw r

join dim d
  on d.driver_map_name = r.driver_map_name

-- ✅ remove duplicates caused by non-unique mapping
qualify row_number() over (
    partition by
        d.driver_sk,
        r.navusoft_driver_id,
        r.navusoft_driver_name,
        d.valid_from
    order by d.record_loaded_at desc
) = 1

order by 1
