{{ config(
    materialized = 'table',
    unique_key   = ['samsara_vehicle_id', 'samsara_vehicle_name', 'vehicle_sk', 'valid_from']
) }}

with samsara_raw as (
    select
        cast(id as string)   as samsara_vehicle_id,
        cast(name as string) as samsara_vehicle_name,

        -- SAME normalization logic used in prep_vehicle.sql
        upper(
            regexp_replace(
                regexp_substr(upper(name), '[A-Z]*-?[0-9]+'),
                '[^A-Z0-9]',
                ''
            )
        ) as vehicle_map_name

    from DB_JTG_DEV.dbt_dtechnician.raw_samsara__vehicle
    where id is not null and name is not null
), dim as (
    select
        vehicle_sk,
        vehicle_map_name,
        valid_from,
        valid_to,
        is_current,
        record_loaded_at
    from DB_JTG_DEV.dbt_dtechnician.dim_vehicle_norm
    where vehicle_map_name is not null
)
select
    d.vehicle_sk,
    r.vehicle_map_name,
    r.samsara_vehicle_id,
    r.samsara_vehicle_name,
    d.valid_from,
    d.valid_to,
    d.is_current,
    d.record_loaded_at,
    md5(
        coalesce(d.vehicle_sk,'') || '|' ||
        coalesce(r.samsara_vehicle_id,'') || '|' ||
        coalesce(r.samsara_vehicle_name,'') || '|' ||
        coalesce(to_varchar(d.valid_from),'')
    ) as bridge_row_hash,
    current_timestamp()::timestamp_ltz as created_at,
    current_timestamp()::timestamp_ltz as updated_at
from samsara_raw r
join dim d
  on d.vehicle_map_name = r.vehicle_map_name

qualify row_number() over (
    partition by d.vehicle_sk, r.samsara_vehicle_id, r.samsara_vehicle_name, d.valid_from
    order by d.record_loaded_at desc
) = 1
order by 1