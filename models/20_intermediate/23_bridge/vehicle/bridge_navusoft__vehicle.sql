{{ config(
    materialized = 'table',
    tags=['bridge'],
    unique_key   = ['navusoft_vehicle_id', 'navusoft_vehicle_name', 'vehicle_sk', 'valid_from']
) }}

with navusoft_raw as (
    select distinct
        cast(truck_id as string)   as navusoft_vehicle_id,
        cast(truck_name as string) as navusoft_vehicle_name,

        -- SAME normalization logic used in prep_vehicle.sql
        upper(
            regexp_replace(
                regexp_substr(upper(truck_name), '[A-Z]*-?[0-9]+'),
                '[^A-Z0-9]',
                ''
            )
        ) as vehicle_map_name

    from {{ref('raw_navusoft__work_order')}}
    where truck_id is not null and truck_name is not null
), dim as (
    select
        vehicle_sk,
        vehicle_map_name,
        valid_from,
        valid_to,
        is_current,
        record_loaded_at
    from {{ref('dim_vehicle')}}
    where vehicle_map_name is not null
)
select
    d.vehicle_sk,
    r.vehicle_map_name,
    r.navusoft_vehicle_id,
    r.navusoft_vehicle_name,
    d.valid_from,
    d.valid_to,
    d.is_current,
    d.record_loaded_at,
    md5(
        coalesce(d.vehicle_sk,'') || '|' ||
        coalesce(r.navusoft_vehicle_id,'') || '|' ||
        coalesce(r.navusoft_vehicle_name,'') || '|' ||
        coalesce(to_varchar(d.valid_from),'')
    ) as bridge_row_hash,
    current_timestamp()::timestamp_ltz as created_at,
    current_timestamp()::timestamp_ltz as updated_at
from navusoft_raw r
join dim d
  on d.vehicle_map_name = r.vehicle_map_name

qualify row_number() over (
    partition by d.vehicle_sk, r.navusoft_vehicle_id, r.navusoft_vehicle_name, d.valid_from
    order by d.record_loaded_at desc
) = 1
order by 1