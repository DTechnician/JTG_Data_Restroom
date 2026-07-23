{{ config(
    materialized='view'
) }}

select 
    driver_name,
    adp_driver_id,
    navusoft_driver_id,
   case when navusoft_driver_id is null then 'UNMAPPED' else 'MAPPED' end as mapping_ind,
from {{ref('raw_prep__driver')}}
