{{ config(materialized='table') }}

with route_execution as (

    select
        route_execution_key,
        route_id,
        route_name,
        service_date,
        division_id,
        division_name,
        route_duration_minutes_estimated,
        fuel_consumed_ml
    from {{ ref('fact_route_execution') }}

),

-- 1️⃣ Fuel cost calculation
fuel_cost as (
    select
        route_execution_key,
        (fuel_consumed_ml / 3785411) * {{ var('fuel_cost_per_gallon', 4.00) }} as fuel_cost
    from route_execution
),

-- 2️⃣ Labor cost calculation (example: $30/hour)
labor_cost as (
    select
        route_execution_key,
        (route_duration_minutes_estimated / 60.0) * {{ var('driver_hourly_rate', 30) }} as labor_cost
    from route_execution
),

-- 3️⃣ Revenue attribution (division-level, route-level)
route_revenue as (
    select
        r.route_execution_key,
        rev.site_id,
        coalesce(sum(rev.amount), 0) as route_revenue
    from route_execution r
    left join {{ ref('stg_navusoft_revenue') }} rev
      on r.service_date = rev.service_date
     and r.division_id  = rev.division_id
    group by all
),

aggregated as (
    select
        r.route_execution_key,
        rr.site_id,
        r.route_id,
        r.route_name,
        r.service_date,
        r.division_id,
        r.division_name,

        -- Revenue
        rr.route_revenue,

        -- Cost components
        fc.fuel_cost,
        lc.labor_cost,

        -- Total route cost
        (coalesce(fc.fuel_cost, 0) + coalesce(lc.labor_cost, 0)) as total_route_cost,

        -- Margin
        (coalesce(rr.route_revenue, 0) - coalesce(total_route_cost, 0)) as route_margin

    from route_execution r
    left join route_revenue rr
    on r.route_execution_key = rr.route_execution_key
    left join fuel_cost fc
    on r.route_execution_key = fc.route_execution_key
    left join labor_cost lc
    on r.route_execution_key = lc.route_execution_key
)

select
    {{ generate_surrogate_key([
                'a.route_execution_key',
                'a.site_id'
    ]) }} as route_financial_key,
    route_execution_key,
    --DIMENSION KEYS---
    dr.route_key,
    d.division_key,
    s_dt.date_sk as service_date_key,
    s.ACCOUNT_AND_SITE_SK as site_key,
    --MEASURES---
    a.route_id,
    a.route_name,
    a.service_date,
    a.division_id,
    a.division_name,
    -- Cost components
    a.fuel_cost,
    a.labor_cost,
    -- Revenue & Cost
    a.route_revenue,
    a.total_route_cost,
    -- Margin
    a.route_margin
from aggregated a
left join {{ ref('dim_route') }} dr
  on a.route_id    = dr.route_id
 and a.division_id = dr.division_id
left join {{ ref('dim_site_division') }} d
    on a.division_id = d.division_id
left join {{ ref('dim_date') }} s_dt
    on a.service_date = s_dt.date
left join {{ ref('dim_site') }} s
    on a.site_id = s.site_id
        