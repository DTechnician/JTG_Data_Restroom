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
        select work_order_sk, v.vehicle_map_name, scheduled_date, wo.vehicle_sk,
            --completed services (status 3, scheduled and completed within the same day)--
                case
                    when status = 3 and completion_date = scheduled_date
                        then quantity
                end as completed_services,
            --late services (status 3, but scheduled and completed are only within the same week)--    
                case
                    when status = 3
                        and completion_date <> scheduled_date
                        and date_trunc('week', completion_date)
                            = date_trunc('week', scheduled_date)
                    then quantity
                end as late_services,
            --missed services (status 0,1,2, or 3 but sechuledw week has been missed)--    
                case
                    when status in (0,1,2)
                        or (
                            status = 3
                            and date_trunc('week', completion_date)
                                <> date_trunc('week', scheduled_date)
                            )
                    then quantity
                end as missed_services,                
            --
        from dim_work_order wo
        join dim_vehicle v on wo.vehicle_sk = v.vehicle_sk
    ),

    final as (
        select 
            sd.work_order_sk,
            d.date_sk as trip_date_sk,
            tm.vehicle_sk,
                /* services measures*/
                completed_services,
                late_services,
                missed_services,
                /* allocation divisor */
                case 
                    when count(sd.work_order_sk) over (partition by sd.vehicle_sk,sd.scheduled_date)  = 0 then 1
                    else count(sd.work_order_sk) over (partition by sd.vehicle_sk,sd.scheduled_date)
                end as workorder_count, 
                /* allocated measures */
                tm.minutes_taken / workorder_count as allocated_minutes_taken,
                tm.hours_taken / workorder_count as allocated_hours_taken,
                tm.distance_meters / workorder_count as allocated_distance_meters,
                tm.distance_miles / workorder_count as allocated_distance_miles,
                tm.fuel_consumed_ml / workorder_count as allocated_fuel_consumed_ml,
                tm.fuel_consumed_liters / workorder_count as allocated_fuel_consumed_liters
                    
        from trip_measures tm  
        left join service_details sd  
            on sd.scheduled_date = tm.trip_start_date
            and sd.vehicle_sk = tm.vehicle_sk
        join {{ref('dim_date')}} d on tm.trip_start_date = d.date
        order by tm.vehicle_map_name, sd.scheduled_date
    )
 
 select * from final