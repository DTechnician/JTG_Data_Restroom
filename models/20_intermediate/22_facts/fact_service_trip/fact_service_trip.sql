{{ config(
    materialized='table',
    tags=['facts']
    ) }}
    
with 
    fact_vehicle_trip as (select * from {{ref('fact_vehicle_trip')}}),

    bridge_samsara__vehicle as (select * from {{ref('bridge_samsara__vehicle')}}),
    
    bridge_navusoft__vehicle as (select * from {{ref('bridge_navusoft__vehicle')}}),

    dim_work_order as (select * from {{ref('dim_work_order')}}),

    dim_vehicle as (select * from {{ref('dim_vehicle')}}),
    
    trip_measures as (
        select 
            bsv.vehicle_sk,
            bsv.vehicle_map_name,
            bsv.samsara_vehicle_name,
            to_date({{ms_to_datetime('vt.start_ms')}}) trip_start_date, 
            sum(coalesce(datediff(min,{{ms_to_datetime('vt.start_ms')}}, {{ms_to_datetime('vt.end_ms')}}),0)) as minutes_taken,
            (minutes_taken/60)::numeric(18,2) as hours_taken,
            sum(vt.distance_meters) distance_meters,
            sum(vt.distance_meters* 0.000621371) distance_miles,           
            sum(vt.fuel_consumed_ml) fuel_consumed_ml,
            sum(vt.fuel_consumed_ml/1000) fuel_consumed_liters 
        from fact_vehicle_trip vt 
        left join bridge_samsara__vehicle bsv on vt.vehicle_id = bsv.samsara_vehicle_id
        group by all
    ),

    service_details as (
        select work_order_sk, v.vehicle_map_name, scheduled_date, wo.vehicle_sk
        from dim_work_order wo
        join dim_vehicle v on wo.vehicle_sk = v.vehicle_sk
    ),

    final as (
        select 
            sd.work_order_sk,
            tm.trip_start_date as trip_date,
                /* allocation divisor */
                count(sd.work_order_sk) over (
                    partition by
                        sd.vehicle_sk,
                        sd.scheduled_date
                ) as workorder_count,
                -- /* total measures*/
                -- tm.distance_meters,
                -- tm.distance_miles,
                -- tm.fuel_consumed_ml,
                -- tm.fuel_consumed_liters,
                /* allocated measures */
                tm.minutes_taken / workorder_count as allocated_minutes_taken,
                tm.hours_taken / workorder_count as allocated_hours_taken,
                tm.distance_meters / workorder_count as allocated_distance_meters,
                tm.distance_miles / workorder_count as allocated_distance_miles,
                tm.fuel_consumed_ml / workorder_count as allocated_fuel_consumed_ml,
                tm.fuel_consumed_liters / workorder_count as allocated_fuel_consumed_liters
                    
        from  service_details sd  
        left join trip_measures tm 
            on sd.scheduled_date = tm.trip_start_date
            and sd.vehicle_sk = tm.vehicle_sk
        order by tm.vehicle_map_name, sd.scheduled_date
    )
 
 select * from final