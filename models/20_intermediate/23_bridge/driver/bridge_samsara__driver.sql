{{ config(
    materialized = 'incremental',
    unique_key = ['samsara_driver_id'],
    incremental_strategy = 'merge'
) }}

with source as (

    select
        samsara_driver_id,
        samsara_driver_name,
        driver_map_name
    from {{ ref('raw_prep__driver') }}
    where samsara_driver_id is not null

),

dim as (

    select
        *
    from {{ ref('dim_driver') }}
    where is_current = true

),

bridge as (

    select
        s.driver_map_name,
        s.samsara_driver_id,
        s.samsara_driver_name,
        d.driver_sk,
        d.valid_from,
        d.valid_to,
        d.is_current,
        d.record_loaded_at
    from source s
    left join dim d
        on s.driver_map_name = d.driver_map_name

)

select * from bridge