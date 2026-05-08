{{ config(
    materialized = 'table',
    tags=['facts']
) }}

with

active_services AS (

    SELECT
        site_service_history_sk,
        service_id,
        site_id,
        site_division_id,
        lob_id,
        lob_name,
        equipmenttype_name,
        quantity,
        record_loaded_at,
        CAST(start_date AS DATE) AS start_date,
        CAST(COALESCE(end_date, billed_thru_date) AS DATE) AS end_date
    FROM {{ ref('dim_site_service_history') }}
    WHERE is_current = TRUE
),

equipment_utilization AS (

    SELECT
        a.site_service_history_sk,

        d.date AS service_date,

        a.service_id,
        a.site_id,
        a.site_division_id,
        a.lob_id,
        a.lob_name,
        a.equipmenttype_name,

        a.start_date,
        a.end_date,
        
        a.quantity AS active_service_count,
        a.record_loaded_at

    FROM active_services a
    join {{ ref('dim_date') }} d
    ON d.date BETWEEN a.start_date AND a.end_date
    where service_date < CURRENT_DATE()
)

SELECT *
FROM equipment_utilization