with
    audit_landing as (        
         select bsv.vehicle_map_name, samsara_vehicle_name, 
        to_date(case
                    when vt.start_ms is null then null --null ms data
                    when vt.start_ms >= 32503680000000 then null --invalid ms data 
                    when vt.start_ms < 0 then null --invalid ms data
                    else to_timestamp(vt.start_ms / 1000) --valid values
                end) trip_start_date,
        sum(coalesce(datediff(min,case
                    when vt.start_ms is null then null --null ms data
                    when vt.start_ms >= 32503680000000 then null --invalid ms data 
                    when vt.start_ms < 0 then null --invalid ms data
                    else to_timestamp(vt.start_ms / 1000) --valid values
                end, case
                    when vt.end_ms is null then null --null ms data
                    when vt.end_ms >= 32503680000000 then null --invalid ms data 
                    when vt.end_ms < 0 then null --invalid ms data
                    else to_timestamp(vt.end_ms / 1000) --valid values
                end),0)) as minutes_taken,
        sum(vt.distance_meters) as distance_meters,
        sum(vt.fuel_consumed_ml) as fuel_consumed_ml, 
        from {{ref('raw_samsara__vehicle_trip')}} vt
        left join {{ref('bridge_samsara__vehicle')}} bsv on vt.vehicle_id = bsv.samsara_vehicle_id
        group by all
    ),

    audit_fact as (
        select v.vehicle_map_name, v.samsara_vehicle_name,  dt.date, 
        sum(allocated_minutes_taken) as minutes_taken, 
        sum(allocated_distance_meters) as distance_meters, 
        sum(allocated_fuel_consumed_ml) as fuel_consumed_ml
        from {{ref('fact_service_trip')}} st
        join {{ref('dim_vehicle')}} v on st.vehicle_sk = v.vehicle_sk
        join {{ref('dim_date')}} dt on st.trip_date_sk = dt.date_sk
        group by all
        order by all
    ),

    audit_report_view as (
        select 2 as data_touch_point_id, 'FACT' as data_touch_point,*
        from audit_fact
        union all
        select 1 as data_touch_point_id, 'RAW' as data_touch_point,*
        from audit_landing
    )

select *
from audit_report_view