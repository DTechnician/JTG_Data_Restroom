{{ config(
    materialized = 'table'
) }}

with route_source as (

    select distinct
        route_id,
        route_name,
        division_id,
        -- min(service_date) over (partition by route_id, division_id) as first_seen_date,
        -- max(service_date) over (partition by route_id, division_id) as last_seen_date
    from {{ ref('raw_navusoft__daily_route_productivity') }}
    where route_id is not null

),

division as (

    select distinct
        site_division_id as division_id,
        site_division_name as division_name
    from {{ ref('dim_site') }}

)


select
    {{ generate_surrogate_key([
        'rs.route_id',
        'd.division_id'
    ]) }} as route_key,

    rs.route_id,
    rs.route_name,

    rs.division_id,
    d.division_name,

    true as is_active,
    -- rs.first_seen_date,
    -- rs.last_seen_date

from route_source rs
left join division d
    on rs.division_id = d.division_id