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
        coalesce(coalesce(rate,0)/sfm.sf_value, 0) as calculated_revenue,
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

            --date measures
            datediff(minute ,calculated_start_timestamp, calculated_end_timestamp) as calculated_timestamp_duration,
            datediff(minute ,start_timestamp_override, end_timestamp_override) as override_timestamp_duration,
            datediff(minute ,geofence_start_time_stamp, geofence_start_time_stamp) as geofence_timestamp_duration,

            --financials
            act.calculated_revenue as revenue,
            (coalesce(calculated_timestamp_duration,0)*sd.division_hourly_rate)/60 as labor_cost,
            act.calculated_revenue-labor_cost as profit_margin,
        
        from stg_navusoft_work_order wo
        join dim_work_order dwo on wo.workordernumber = dwo.workordernumber
        left join stg_navusoft_site_service_history act on wo.siteservice_id = act.service_id
        left join dim_site_division sd on wo.division_id =  sd.division_id
        where act.calculated_revenue <> 0
    )

select *
from final

