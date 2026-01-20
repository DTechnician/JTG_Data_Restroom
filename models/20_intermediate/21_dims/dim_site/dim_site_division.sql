{{ config(
    materialized = 'table'
) }}

with division as (

    select distinct
        {{ generate_surrogate_key([
        'd.site_division_id'
        ]) }} as division_key,
        site_division_id as division_id,
        site_division_name as division_name
    from {{ ref('dim_site') }} d

)

select * from division