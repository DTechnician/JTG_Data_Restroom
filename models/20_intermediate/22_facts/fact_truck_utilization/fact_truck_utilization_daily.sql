{{ config(
    materialized='table',
    tags=['facts']
    ) }}

with 

vehicle_obd_reset as (

    SELECT
        vehicle_id,
        DATE(time) AS obd_date,
        time,
        value,
        value - LAG(value) OVER (
            PARTITION BY vehicle_id, DATE(time)
            ORDER BY time
        ) AS delta_seconds
    FROM {{ ref('dim_obd_engine_second') }}
),

vehicle_obd as (
        select

        vehicle_id,
        obd_date,
        SUM(
        CASE
            WHEN delta_seconds BETWEEN 0 AND 7200 THEN delta_seconds
            ELSE 0
        END ) / 3600.0 AS engine_hours_on
        from vehicle_obd_reset
        group by vehicle_id, obd_date
        order by engine_hours_on desc
),

vehicle_function as (
    SELECT 

            id,
            name,
            function as vehicle_function,
            division as vehicle_division
            from {{ ref('truck_function') }}

),

samsara_trip as (

    select
        vt.driver_id,
        vt.vehicle_id,
        d.name as driver_name,
        v.samsara_vehicle_name as vehicle_name,
        vt.distance_meters as distance_m,
        vf.vehicle_function,
        vf.vehicle_division,
        
        to_timestamp(start_ms, 3) as start_date,

        case
            when end_ms = 9223372036854775807 then null
            else to_timestamp(end_ms, 3)
        end as end_date,

        (vt.distance_meters / 1609.34) as distance_mi,
        
        fuel_consumed_ml,
        (fuel_consumed_ml / 3785.41) as fuel_consumed_gal

    from {{ ref('dim_vehicle_trip') }} vt
    left join {{ ref('bridge_samsara__vehicle') }} v
        on vt.vehicle_id = v.samsara_vehicle_id
    left join {{ ref('raw_samsara__driver') }} d
        on vt.driver_id = d.id
    left join vehicle_function vf
        on vt.vehicle_id = vf.id
)

, aggregated as (

    select
        vehicle_name,
        date(start_date) as trip_day,
        DATE_PART('week', DATEADD(day, 1, start_date)) as trip_week,
        vehicle_function,
        vehicle_division,

        SUM(distance_mi) as total_distance_mi,
        SUM(fuel_consumed_ml) as total_fuel_consump_ml,
        SUM(fuel_consumed_gal) as total_fuel_consump_gal,
        MAX(engine_hours_on) as engine_on_hrs,
        MAX(engine_hours_on) / 60 * 100 AS utilization_percent


    from samsara_trip st
    left join vehicle_obd obd
    on st.vehicle_id = obd.vehicle_id
    and trip_day = obd_date
    group by
    vehicle_name, trip_day, trip_week, vehicle_function, vehicle_division
)

select
    --surrogate key--
    MD5(CONCAT(vehicle_name, trip_day)) AS surrogate_key,

    --DIM KEYS--
    s_dt.date_sk as service_date_key,
    
    --MEASURES---

    a.vehicle_name,
    a.trip_day,
    a.trip_week,
    a.vehicle_function,
    a.vehicle_division,

    total_distance_mi,
    total_fuel_consump_ml,
    total_fuel_consump_gal,
    engine_on_hrs,
    utilization_percent

from aggregated a
left join {{ ref('dim_date') }} s_dt
on trip_day = s_dt.date
where surrogate_key is not null
order by trip_day desc