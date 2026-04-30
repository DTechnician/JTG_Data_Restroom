{{ config(
    materialized = 'table',
    tags=['facts']
) }}

with

active_services AS (

    SELECT
        active_services_sk,
        siteservice_id,
        site_id,
        division_id,
        lob_id,
        lob_name,
        eqquipmenttype_name,
        equipmenttype_id,
        servicecode_id,
        quantity,
        record_loaded_at,
        CAST(startdate AS DATE) AS start_date,
        CAST(COALESCE(enddate, billed_through_date) AS DATE) AS end_date
    FROM {{ ref('dim_active_services') }}
    WHERE is_current = TRUE
),

equipment_utilization AS (

    SELECT
        a.active_services_sk,

        d.date AS service_date,

        a.siteservice_id,
        a.site_id,
        a.division_id,
        a.lob_id,
        a.lob_name,
        a.eqquipmenttype_name,
        a.equipmenttype_id,
        a.servicecode_id,

        a.quantity AS active_toilet_count,
        a.record_loaded_at

    FROM active_services a
    join {{ ref('dim_date') }} d
    ON d.date BETWEEN a.start_date AND a.end_date
    WHERE service_date >= CURRENT_DATE()
)

SELECT *
FROM equipment_utilization