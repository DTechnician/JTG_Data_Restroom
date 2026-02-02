{{ config(materialized='table') }}


with 
--set up dimensions--
    dim_route as (
        select *
        from {{ref('dim_route')}}
        group by all
    ),
    
    dim_service_code as (
        select *
        from {{ref('dim_service_code')}}
    ),
    
    dim_equipment_type as (
        select *
        from {{ref('dim_equipment_type')}}
    ),

    dim_site as (
        select *
        from {{ref('dim_site')}}
    ),

    dim_site_division as (
        select *
        from {{ref('dim_site_division')}}
    ),

    dim_work_type as (
        select *
        from {{ref('dim_work_type')}}
    ),    
    
    dim_driver as (
        select *
        from {{ref('dim_driver_navusoft')}}
    ),

    dim_vehicle as (
        select *
        from {{ref('dim_vehicle_navusoft')}}
    ),

    stg_navusoft_work_order as (
        select * 
        from {{ref('stg_navusoft_work_order')}}
    ),

    stg_navusoft_site_service_history as (
        select * from {{ref('stg_navusoft_site_service_history')}}
    ),

    
    final as (
        select 
            --DIM SK KEYS--
            s.account_and_site_sk,
            r.route_key,
            wt.work_type_sk ,
            d.driver_sk,
            v.vehicle_sk,
            sc.service_code_sk,
            et.equipment_type_sk,
            sd.division_key,
            comp_dt.date_sk as completion_date_sk,
            sched_dt.date_sk as scheduled_date_sk,
            ----------
            wo.completion_date,
            wo.scheduled_date,
            wo.route_id,
            r.route_name,
            wo.truck_id,
            v.vehicle_id as truck_no,
            v.vehicle_name as truck_name,
            wo.driver_id,
            d.driver_name as driver_name,
            wo.division_id,
            wo.lob_id,
            wo.SITESERVICE_ID as SITESERVICE_ID,
            wo.SERVICECODE_ID as service_code_id,
            sc.service_code_name as service_code_name,
            wo.equipment_type_id as equipment_type_id,
            et.equipment_type_name as eqipment_type_name,
            wt.work_type_id,
            wo.quantity as services,
            case when status_text in ('Service Completed') then wo.quantity else null end as completed_services,
            case  when status_text not in ('Cancelled','Service Completed') then wo.quantity else null end as missed_services,
            wo.status,
            wo.posting_status,
            wo.posted_status_name,

            --hours_taken
            datediff(minute ,calculated_start_timestamp, calculated_end_timestamp) as calculated_timestamp_duration,
            datediff(minute ,start_timestamp_override, end_timestamp_override) as override_timestamp_duration,
            datediff(minute ,geofence_start_time_stamp, geofence_start_time_stamp) as geofence_timestamp_duration,

            -- --revenue
            -- wo.workorder_revenue,
            -- wo.revenue,
            -- wo.surcharge_revenue,
            -- (coalesce(wo.revenue,0) + coalesce(wo.surcharge_revenue,0) +coalesce(wo.workorder_revenue,0)) as revenue_amount,
            -- case when revenue_amount = 0 then 1 else null end as total_zero_count,
            -- case when total_zero_count =1 then case when wo.division_id in (1002,1003) then 35 else 25 end  end as est_revenue,
            -- coalesce(revenue_amount,0)+coalesce(est_revenue,0) as total_revenue,

            act.calculated_revenue as revenue,
            --labor_cost
            (coalesce(calculated_timestamp_duration,0)*sd.division_hourly_rate)/60 as labor_cost,

            --margin
            act.calculated_revenue-labor_cost as profit_margin,

            s.site_id,
            s.site_name,
            s.site_address_line_1,
            s.site_city,
            s.site_state,
            s.site_zip,
            s.site_division_name,
        
        from stg_navusoft_work_order wo
        left join stg_navusoft_site_service_history act on wo.siteservice_id = act.service_id
        left join dim_site s on wo.site_id = s.site_id
        left join dim_route r on wo.route_id = r.route_id
        left join dim_work_type wt on wo.work_type_id = wt.work_type_id
        left join dim_driver d on wo.driver_id = d.driver_id
        left join dim_vehicle v on wo.truck_id = v.vehicle_id
        left join dim_service_code sc on wo.SERVICECODE_ID = sc.service_code_id
        left join dim_equipment_type et on wo.equipment_type_id = et.equipment_type_id
        left join dim_site_division sd on wo.division_id =  sd.division_id
        left join dim_date comp_dt on wo.completion_date = comp_dt.date
        left join dim_date sched_dt on wo.scheduled_date = sched_dt.date
    )

select *
from final

