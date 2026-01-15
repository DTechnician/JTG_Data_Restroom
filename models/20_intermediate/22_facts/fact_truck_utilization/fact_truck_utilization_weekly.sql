{{ config(materialized='table') }}

with 

vehicle_obd as (
        select

        vehicle_id,
        week(time) as obd_week,
        (MAX(value) - MIN(value)) / 3600.0 AS engine_hours_on
        from {{ ref('dim_obd_engine_second') }}
        group by vehicle_id, obd_week
        order by engine_hours_on desc

),

vehicle_function as (
    SELECT 

            vehicle_sk,
            id,
            name,

            CASE
                WHEN name ILIKE '%P&D%'
                OR name ILIKE '%#67%'
                OR name ILIKE '%#FL-30%'
                OR name ILIKE '%#FL-32%'
                OR name ILIKE '%#FL-34%'
                OR name ILIKE '%#FL-39%'
                THEN 'P&D'
                ELSE 'Service'
            END AS truck_function

            FROM {{ ref('dim_vehicle') }}
            WHERE NOT (
                name ILIKE '# FL-33 OSMEL%'
            OR name ILIKE '#37 SPARE TRUCK%'
            OR name ILIKE '#unknown%'
            OR name ILIKE 'Deactivated%'
            OR name ILIKE 'Enterprise Rental Truck%'
            OR name ILIKE 'G5JX-MB8-ZMB%'
            OR name ILIKE 'GDZ2-GBK-VRC%'
            OR name ILIKE 'GMSC-DFG-2UE%'
            OR name ILIKE 'Old%'
            OR name ILIKE 'Truck72%'
            OR name ILIKE 'United rental truck%'
            OR name ILIKE 'Z #31%'
            OR name ILIKE 'Z Broken device%'
            OR name ILIKE 'truck na%'
            )
            group by
            vehicle_sk, id, name
),

samsara_trip as (

    select
        vt.driver_id,
        vt.vehicle_id,
        d.name as driver_name,
        v.name as vehicle_name,
        vt.distance_meters as distance_m,
        vf.truck_function,
        
        to_timestamp(start_ms, 3) as start_date,

        case
            when end_ms = 9223372036854775807 then null
            else to_timestamp(end_ms, 3)
        end as end_date,

        date(start_date) as tripe_date,
        week(start_date) as week,

        (vt.distance_meters / 1609.34) as distance_mi,
        
        fuel_consumed_ml,
        (fuel_consumed_ml / 3785.41) as fuel_consumed_gal

    from {{ ref('fact_vehicle_trip') }} vt
    left join {{ ref('dim_vehicle') }} v
        on vt.vehicle_sk = v.vehicle_sk
    left join {{ ref('dim_driver') }} d
        on vt.driver_sk = d.driver_sk
    left join vehicle_function vf
        on vt.vehicle_sk = vf.vehicle_sk
)

, aggregated as (

    select
        st.vehicle_id,
        vehicle_name,
        tripe_date,
        week,
        truck_function,

        SUM(distance_mi) as total_distance_mi,
        SUM(fuel_consumed_ml) as total_fuel_consump_ml,
        SUM(fuel_consumed_gal) as total_fuel_consump_gal,
        MAX(engine_hours_on) as engine_on_hrs,
        MAX(engine_hours_on) / 60 * 100 AS utilization_percent

    from samsara_trip st
    left join vehicle_obd obd
    on st.vehicle_id = obd.vehicle_id
    and st.week = obd.obd_week
    group by
    st.vehicle_id, vehicle_name, tripe_date, week, truck_function
)

select
    --surrogate key--
    MD5(CONCAT(a.vehicle_name, a.week)) AS surrogate_key,

    --MEASURES---

    a.vehicle_name,
    a.tripe_date,
    a.week,

    total_distance_mi,
    total_fuel_consump_ml,
    total_fuel_consump_gal,
    engine_on_hrs,
    utilization_percent,

    a.truck_function

from aggregated a


