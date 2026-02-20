{{ config(
    materialized = 'table'
) }}

with division as (

    select distinct
        {{ generate_surrogate_key([
        'd.site_division_id'
        ]) }} as division_key,
        site_division_id as division_id,
        site_division_name as division_name,
        --division rates
            case 
                when site_division_id in (1001,1004) then 21
                when site_division_id in (1002) then 24
                when site_division_id in (1003) then 27
                end as division_hourly_rate,
            case 
                when site_division_id in (1001,1004) then 31.5
                when site_division_id in (1002) then 36
                when site_division_id in (1003) then 40.5
                end as division_ot_rate,
    from {{ ref('dim_site') }} d

)

select * from division