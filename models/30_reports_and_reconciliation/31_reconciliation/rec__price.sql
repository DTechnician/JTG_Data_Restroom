with
    audit_landing as (        
        select wo.workordernumber, ssh.site_service_id, wo.scheduled_date, ssh.rate, ssh.perunitrate
        from {{ref('raw_navusoft__work_order')}} wo
        left join {{ref('raw_navusoft__site_service_history')}} ssh on wo.siteservice_id = ssh.site_service_id
        where ssh.rate <> 0 or ssh.perunitrate <> 0
    ),

    audit_fact as (
        select wo.workordernumber,  ssh.site_service_id, dt.date as scheduled_date, r.rate, r.perunitrate
        from {{ref('fact_price')}} r
        join {{ref('dim_work_order')}} wo on r.work_order_sk = wo.work_order_sk
        join {{ref('dim_site_service_history')}} ssh on wo.site_service_history_sk =ssh.site_service_history_sk
        join {{ref('dim_date')}} dt on wo.scheduled_date_sk = dt.date_sk
        where r.rate <> 0 or r.perunitrate <> 0
        group by all
        order by all
    ),

    audit_report_view as (
        select 2 as data_touch_point_id, 'FACT' as data_touch_point, workordernumber , site_service_id, scheduled_date, rate, perunitrate
        from audit_fact
        union all
        select 1 as data_touch_point_id, 'RAW' as data_touch_point, workordernumber , site_service_id, scheduled_date, rate, perunitrate
        from audit_landing
    )

select *
from audit_report_view