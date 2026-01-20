{{ config(materialized='table') }}

with nav_route as (

    select
        route_id,
        route_name,
        truckname        as vehicle_name,
        driver_name,
        division_id,
        division_name,
        date(scheduleddate) as service_date,

        /* Truck-number-based normalization */
        upper(
            concat(
                'TRUCK_',
                regexp_substr(truckname, '#([0-9]+)', 1, 1, 'e', 1)
            )
        ) as vehicle_name_norm,

        upper(regexp_replace(driver_name, '[^A-Z0-9]', '')) as driver_name_norm

    from {{ ref('stg_navusoft_daily_route') }}
)

, samsara_trip as (

    select
        vt.driver_id,
        vt.vehicle_id,
        d.name as driver_name,
        v.name as vehicle_name,

        upper(
            concat(
                'TRUCK_',
                regexp_substr(v.name, '#?([0-9]+)', 1, 1, 'e', 1)
            )
        ) as vehicle_name_norm,

        upper(regexp_replace(d.name, '[^A-Z0-9]', '')) as driver_name_norm,

        to_timestamp(start_ms, 3) as start_date,

        case
            when end_ms = 9223372036854775807 then null
            else to_timestamp(end_ms, 3)
        end as end_date,

        fuel_consumed_ml

    from {{ ref('fact_vehicle_trip') }} vt
    left join {{ ref('dim_vehicle') }} v
        on vt.vehicle_sk = v.vehicle_sk
    left join {{ ref('dim_driver') }} d
        on vt.driver_sk = d.driver_sk
)

, matched_route_trip as (

    select
        r.route_id,
        r.route_name,
        r.service_date,

        r.division_id,
        r.division_name,

        r.vehicle_name,
        r.driver_name,

        t.vehicle_id,
        t.driver_id,

        t.start_date,
        t.end_date,
        t.fuel_consumed_ml,

        'VEHICLE_DRIVER_MATCH' as attribution_method,
        98 as match_confidence_pct

    from nav_route r
    join samsara_trip t
      on r.vehicle_name_norm = t.vehicle_name_norm
     and r.driver_name_norm  = t.driver_name_norm
     and date(t.start_date)  = r.service_date
)

, aggregated as (

    select
        route_id,
        route_name,
        service_date,

        division_id,
        division_name,

        vehicle_name,
        driver_name,

        min(start_date) as route_start_time_estimated,
        max(end_date)   as route_end_time_estimated,

        datediff(
            minute,
            min(start_date),
            max(end_date)
        ) as route_duration_minutes_estimated,

        sum(fuel_consumed_ml) as fuel_consumed_ml,

        attribution_method,
        match_confidence_pct

    from matched_route_trip
    group by
        route_id,
        route_name,
        service_date,
        division_id,
        division_name,
        vehicle_name,
        driver_name,
        attribution_method,
        match_confidence_pct
)

select
    {{ generate_surrogate_key([
                'a.route_id',
                'a.service_date'
    ]) }} as route_execution_key,
    --DIMENSION KEYS---
    dr.route_key,
    d.division_key,
    s_dt.date_sk as service_date_key,
    --MEASURES---
    a.route_id,
    a.route_name,
    a.service_date,

    a.division_id,
    a.division_name,

    a.vehicle_name,
    a.driver_name,

    a.route_start_time_estimated,
    a.route_end_time_estimated,
    a.route_duration_minutes_estimated,

    a.fuel_consumed_ml,
    a.attribution_method,
    a.match_confidence_pct

from aggregated a
left join {{ ref('dim_route') }} dr
  on a.route_id    = dr.route_id
 and a.division_id = dr.division_id
left join {{ ref('dim_site_division') }} d
    on a.division_id = d.division_id
left join {{ ref('dim_date') }} s_dt
    on a.service_date = s_dt.date