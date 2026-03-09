{{ config(materialized='table') }}


with 
--set up dimensions--
    dim_route as (
        select *
        from {{ref('dim_route')}}
    ),
    
    dim_service_code as (
        select *
        from {{ref('dim_service_code')}}
    ),
    
    dim_equipment_type as (
        select *
        from {{ref('dim_equipment_type')}}
    ),
    
    dim_line_of_business as (
        select *
        from {{ref('dim_line_of_business')}}
    ),

    dim_date as (
        select *
        from {{ref('dim_date')}}
    ),

    dim_site as (
        select *
        from {{ref('dim_site')}}
    ),

    dim_account as (
        select *
        from {{ref('dim_account')}}
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
        from {{ref('raw_navusoft__work_order')}}
    ),

    stg_navusoft_site_service_history as (
        select *,
        sfm.sf_value,
        rate/sfm.sf_value as calculated_revenue,
        /* duration */
        case
            when start_date is not null
                and end_date   is not null
                and end_date   >= start_date
            then datediff(minute, start_date, end_date)
            else null
        end as service_duration_minutes,
        from {{ref('raw_navusoft__site_service_history')}} ssh
        left join {{ref('service_frequency_mapping')}} sfm on ssh.service_frequency = sfm.service_frequency
    ),

    
    final as (
        select 
            --DIM SK KEYS--
            s.account_and_site_sk site_sk,
            a.account_sk account_sk,
            r.route_key,
            wt.work_type_sk ,
            d.driver_sk,
            v.vehicle_sk,
            sc.service_code_sk,
            et.equipment_type_sk,
            sd.division_key,
            lob.lob_sk,
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
            wo.site_id,
            wo.account_id,
            wo.SITESERVICE_ID as SITESERVICE_ID,
            wo.SERVICECODE_ID as service_code_id,
            wo.equipment_type_id as equipment_type_id,
            wt.work_type_id,
            wo.quantity as services,
            wo.quantity as unit,
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
            act.calculated_revenue as revenue,
            act.rate as rate,
            act.perunitrate as perunitrate,

            --labor_cost
            (coalesce(calculated_timestamp_duration,0)*sd.division_hourly_rate)/60 as labor_cost,

            --margin
            act.calculated_revenue-labor_cost as profit_margin,
        
        from stg_navusoft_work_order wo
        left join stg_navusoft_site_service_history act on wo.siteservice_id = act.service_id
        left join dim_site s on wo.site_id = s.site_id
        left join dim_account a on wo.account_id = a.account_id
        left join dim_route r on wo.route_id = r.route_id
        left join dim_work_type wt on wo.work_type_id = wt.work_type_id
        left join dim_driver d on wo.driver_id = d.driver_id
        left join dim_vehicle v on wo.truck_id = v.vehicle_id
        left join dim_service_code sc on wo.SERVICECODE_ID = sc.service_code_id
        left join dim_equipment_type et on wo.equipment_type_id = et.equipment_type_id
        left join dim_line_of_business lob on wo.lob_id = lob.lob_id
        left join dim_site_division sd on wo.division_id =  sd.division_id
        left join dim_date comp_dt on wo.completion_date = comp_dt.date
        left join dim_date sched_dt on wo.scheduled_date = sched_dt.date
    )

select *
from final

