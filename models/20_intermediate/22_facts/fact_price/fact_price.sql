{{ config(
    materialized='table',
    tags=['facts']
    ) }}


with 
--set up dimensions--
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
    dim_work_order as (select * from {{ref('dim_work_order')}}),
    
    final as (
        select 
            --DIM SK KEYS--
            dwo.work_order_sk,

            --financials
            -- --price
            act.rate as rate,
            act.perunitrate as perunitrate,
        
        from stg_navusoft_work_order wo
        join dim_work_order dwo on wo.workordernumber = dwo.workordernumber
        left join stg_navusoft_site_service_history act on wo.siteservice_id = act.service_id
        where rate <> 0
    )

select *
from final

