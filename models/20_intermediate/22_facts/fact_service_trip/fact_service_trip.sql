{{ config(
    materialized='table',
    tags=['facts']
    ) }}
    
with 
    fact_vehicle_trip as (select * from {{ref('fact_vehicle_trip')}}),

    bridge_samsara__vehicle as (select * from {{ref('bridge_samsara__vehicle')}}),
    
    bridge_navusoft__vehicle as (select * from {{ref('bridge_navusoft__vehicle')}}),

    dim_work_order as (select * from {{ref('dim_work_order')}}),
    
    trip_measures as (
        select 
            bsv.vehicle_sk,
            bsv.vehicle_map_name,
            bsv.samsara_vehicle_name,
            to_date(to_timestamp(vt.start_ms / 1000)) trip_start_date, 
            sum(vt.distance_meters) distance_meters,
            sum(vt.distance_meters* 0.000621371) distance_miles,           
            sum(vt.fuel_consumed_ml) fuel_consumed_ml,
            sum(vt.fuel_consumed_ml/1000) fuel_consumed_liters 
        from fact_vehicle_trip vt 
        left join bridge_samsara__vehicle bsv on vt.vehicle_id = bsv.samsara_vehicle_id
        group by all
    ),

    service_details as (
        select work_order_sk, siteservice_id, scheduled_date, vehicle_sk
        from dim_work_order wo
    ),

    final as (
        select 
            sd.work_order_sk,
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
                tm.distance_meters / workorder_count as allocated_distance_meters,
                tm.distance_miles / workorder_count as allocated_distance_miles,
                tm.fuel_consumed_ml / workorder_count as allocated_fuel_consumed_ml,
                tm.fuel_consumed_liters / workorder_count as allocated_fuel_consumed_liters
                    
        from  service_details sd  
        join trip_measures tm 
            on sd.scheduled_date = tm.trip_start_date
            and sd.vehicle_sk = tm.vehicle_sk
        order by tm.vehicle_map_name, sd.scheduled_date
    )
 
 select * from final