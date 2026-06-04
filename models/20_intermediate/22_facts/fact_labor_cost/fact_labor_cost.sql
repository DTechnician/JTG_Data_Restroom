WITH 
    fact_vehicle_trip AS (
        SELECT
            *,
            {{ clean_ms('vt.start_ms') }} AS clean_start_ms,
            {{ clean_ms('vt.end_ms') }} AS clean_end_ms
        FROM {{ ref('fact_vehicle_trip') }} vt
    ),

    trip_hours AS (
        SELECT
            bsd.driver_sk,
            bsd.driver_map_name,
            bsd.samsara_driver_id,
            bsd.samsara_driver_name,

            TO_DATE(TO_TIMESTAMP(clean_start_ms / 1000)) AS trip_start_date,

            SUM(
                    CASE
                        WHEN clean_start_ms IS NULL OR clean_end_ms IS NULL
                            THEN NULL
                        WHEN clean_start_ms >= clean_end_ms
                            THEN  (clean_start_ms - clean_end_ms) / (1000.0 * 60 * 60)
                        ELSE NULL
                    END
            )::numeric(12,2) AS trip_hours

        FROM fact_vehicle_trip vt 
        LEFT JOIN {{ ref('bridge_samsara__vehicle') }} bsv 
            ON vt.vehicle_id = bsv.samsara_vehicle_id
        LEFT JOIN {{ ref('bridge_samsara__driver') }} bsd 
            ON vt.driver_id = bsd.samsara_driver_id

        GROUP BY ALL
    ),

    driver_labor_cost as (
        select  
            d.driver_sk,
            tc.date, 
            coalesce(adp_hourly_rate,0)::numeric(12,2) as adp_hourly_rate, 
            tc.hours::numeric(12,2) as timecard_hours,
            th.trip_hours::numeric(12,2) as trip_hours, 
            tc.hours * coalesce(adp_hourly_rate,0)::numeric(12,2) as timecard_labor_cost,
            th.trip_hours * coalesce(adp_hourly_rate,0)::numeric(12,2) as trip_labor_cost,
        from {{ref('dim_driver')}} d  
        full outer join db_jtg_dev.dbt_dtechnician.dim_date dt on 1=1
        left join {{ref('raw_adp__timecards')}} tc
            on tc.worker_id = d.adp_associate_id and dt.date = tc.date
        left join trip_hours th 
            on d.driver_sk = th.driver_sk and dt.date = th.trip_start_date
        where timecard_labor_cost <> 0 or trip_labor_cost <> 0
    ),
    
    service_details as (
        select work_order_sk, scheduled_date, d.driver_sk
        from {{ref('dim_work_order')}}  wo
        left join {{ref('dim_driver')}} d on wo.driver_sk = d.driver_sk
    ),

    final as (
    select 
        sd.driver_sk, 
        count(sd.work_order_sk) over (
                        partition by
                            sd.driver_sk,
                            sd.scheduled_date
                    ) as workorder_count, 
        dlc.trip_hours / workorder_count as allocated_trip_hours,
        dlc.timecard_hours / workorder_count as allocated_timecard_hours,
        dlc.timecard_labor_cost / workorder_count as allocated_timecard__hours,
        dlc.trip_labor_cost / workorder_count as allocated_trip_labor_cost,
    from service_details sd
    left join driver_labor_cost dlc 
        on sd.driver_sk = dlc.driver_sk
        and sd.scheduled_date = dlc.date
    order by 1,2
    )

select * from final