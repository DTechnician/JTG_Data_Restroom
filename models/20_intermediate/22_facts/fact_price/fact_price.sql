{{ config(materialized='table') }}


with 
--set up dimensions--
    dim_route as (
        select *
        from {{ref('dim_work_order')}}
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
            dwo.work_order_sk,
            comp_dt.date_sk as completion_date_sk,
            sched_dt.date_sk as scheduled_date_sk,

            --date measures
            datediff(minute ,calculated_start_timestamp, calculated_end_timestamp) as calculated_timestamp_duration,
            datediff(minute ,start_timestamp_override, end_timestamp_override) as override_timestamp_duration,
            datediff(minute ,geofence_start_time_stamp, geofence_start_time_stamp) as geofence_timestamp_duration,

            --financials
            -- --price
            act.rate as rate,
            act.perunitrate as perunitrate,
        
        from stg_navusoft_work_order wo
        join dim_work_order dwo on wo.workordernumber = dwo.workordernumber
        left join stg_navusoft_site_service_history act on wo.siteservice_id = act.service_id
        left join dim_site_division sd on wo.division_id =  sd.division_id
        left join dim_date comp_dt on wo.completion_date = comp_dt.date
        left join dim_date sched_dt on wo.scheduled_date = sched_dt.date
        where rate <> 0
    )

select *
from final

