WITH 

    worker_labor_cost as (
        select  
            d.worker_sk,
            tc.date, 
            coalesce(d.hourly_rate,0)::numeric(12,2) as adp_hourly_rate, 
            coalesce(d.overtime_hourly_rate,0)::numeric(12,2) as adp_overtime_hourly_rate,
            tc.regular_hours::numeric(12,2) as timecard_regular_hours,
            tc.regular_hours * coalesce(adp_hourly_rate,0)::numeric(12,2) as timecard_regular_labor_cost,
            tc.overtime_hours::numeric(12,2) as timecard_overtime_hours,
            tc.overtime_hours * coalesce(adp_overtime_hourly_rate,0)::numeric(12,2) as timecard_overtime_labor_cost,
            tc.hours::numeric(12,2) as timecard_hours,
            (timecard_regular_labor_cost+timecard_overtime_labor_cost)::numeric(12,2) as timecard_labor_cost,
        from {{ref('dim_worker')}} d  
        full outer join {{ref('dim_date')}} dt on 1=1
        left join {{ref('raw_adp__timecards')}} tc
            on tc.associate_id = d.associate_oid and dt.date = tc.date
        where timecard_hours <> 0
    ),
    
    service_details as (
        select work_order_sk, scheduled_date, d.worker_sk
        from {{ref('dim_work_order')}}  wo
        left join {{ref('dim_worker')}} d on wo.worker_sk = d.worker_sk
    ),

    final as (
    select 
        sd.work_order_sk, 
        dlc.worker_sk,
        dt.date_sk as timecard_date_sk,
        case 
            when count(sd.work_order_sk) over (partition by sd.worker_sk,sd.scheduled_date)  = 0 then 1
            else count(sd.work_order_sk) over (partition by sd.worker_sk,sd.scheduled_date)
        end as workorder_count, 
        dlc.timecard_hours / workorder_count as allocated_total_hours,
        dlc.timecard_labor_cost / workorder_count as allocated_total_labor_cost,
        dlc.timecard_regular_hours / workorder_count as allocated_regular_hours,
        dlc.timecard_regular_labor_cost / workorder_count as allocated_regular_labor_cost,
        dlc.timecard_overtime_hours / workorder_count as allocated_overtime_hours,
        dlc.timecard_overtime_labor_cost / workorder_count as allocated_overtime_labor_cost,
    from worker_labor_cost dlc
    left join service_details sd
    on sd.worker_sk = dlc.worker_sk
        and sd.scheduled_date = dlc.date
    left join {{ref('dim_date')}} dt 
    on dlc.date = dt.date
    where timecard_hours is not null
    order by 1,2
    )

select * from final