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
        from {{ref('raw_navusoft__site_service_history')}} ssh
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
        left join stg_navusoft_site_service_history act on wo.siteservice_id = act.site_service_id
        where rate <> 0
    )

select *
from final

