{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

with 

    driver_navusoft as (
        select distinct
            {{ generate_surrogate_key([
                        'a.driver_id' 
            ]) }} as driver_sk ,
            driver_id,
            driver_name,
        from 
        {{ref('raw_navusoft__work_order')}} a
    ),

    driver_title_mapping as (
        select * 
        from {{ref('driver_title_mapping')}}
    )

    select dn.*, dtm.driver_title 
    from driver_navusoft dn
    left join driver_title_mapping dtm on dn.driver_id = dtm.driver_id