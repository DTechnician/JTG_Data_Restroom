with
    audit_landing as (        
        select w.worker_name, tc.date, sum(tc.overtime_hours) as overtime_hours, sum(tc.regular_hours) as regular_hours, sum(tc.hours) as total_hours, 
        from {{ref('dim_worker')}} w        
        full outer join {{ref('dim_date')}} dt
        left join {{ref('raw_adp__timecards')}} tc on tc.associate_id = w.associate_oid and dt.date = tc.date
        group by all
        having sum(tc.overtime_hours) <> 0 or sum(tc.regular_hours) <> 0 or sum(tc.hours) <> 0
        order by all
    ),

    audit_fact as (
        select w.worker_name, dt.date, sum(allocated_overtime_hours) as overtime_hours, sum(allocated_regular_hours) as regular_hours, sum(allocated_total_hours) as total_hours
        from {{ref('fact_labor_cost')}} lc
        join {{ref('dim_worker')}} w on lc.worker_sk = w.worker_sk
        join {{ref('dim_date')}} dt on lc.timecard_date_sk = dt.date_sk
        group by all
        order by all
    ),

    audit_report_view as (
        select 2 as data_touch_point_id, 'FACT' as data_touch_point,*
        from audit_fact
        union all
        select 1 as data_touch_point_id, 'RAW' as data_touch_point,*
        from audit_landing
    )

select *
from audit_report_view