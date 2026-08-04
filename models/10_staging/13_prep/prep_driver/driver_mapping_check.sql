{{ config(
    materialized='view'
) }}

select 
    worker_name as driver_name,
    adp_worker_id as adp_driver_id,
    navusoft_driver_id,
   case when navusoft_driver_id is null then 'UNMAPPED' else 'MAPPED' end as mapping_ind,
from {{ref('raw_prep__worker')}}
where lower(job_title) like '%driver%'
