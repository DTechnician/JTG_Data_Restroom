{{ config(materialized='table') }}

with expected_services as (

    select
        a.siteservice_id as servicerecord_id,
        a.site_id,
        r.service_date,
        a.division_id
    from {{ ref('stg_navusoft_active_services') }} a
    join {{ ref('fact_route_execution') }} r
      on a.division_id = r.division_id
),

actual_services as (

    select
        service_id as servicerecord_id,
        site_id,
        start_date as service_date,
        site_division_id as division_id,
        service_duration_minutes
    from {{ ref('stg_navusoft_site_service_history') }}
),

service_events as (

    select
        e.servicerecord_id,
        e.site_id,
        e.service_date,
        e.division_id,

        a.service_duration_minutes,

        case
            when a.servicerecord_id is not null then 'COMPLETED'
            else 'MISSED'
        end as service_status
    from expected_services e
    left join actual_services a
      on e.servicerecord_id = a.servicerecord_id
     and e.service_date = a.service_date
)

select
    {{ generate_surrogate_key([
        'servicerecord_id',
        'service_date'
    ]) }} as service_event_key,
    --DIMENSION KEYS---
    d.division_key,
    s_dt.date_sk as service_date_key,
    s.ACCOUNT_AND_SITE_SK as site_key,

    a.servicerecord_id,
    a.site_id,
    a.service_date,
    a.division_id,
    --MEASURE
    a.service_status,
    a.service_duration_minutes

from service_events a
left join {{ ref('dim_site_division') }} d
    on a.division_id = d.division_id
left join {{ ref('dim_date') }} s_dt
    on a.service_date = s_dt.date
left join {{ ref('dim_site') }} s
    on a.site_id = s.site_id
        