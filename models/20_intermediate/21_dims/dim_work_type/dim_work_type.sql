{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

select distinct
    {{ generate_surrogate_key([
                'a.work_type_id' 
    ]) }} as work_type_sk ,
    work_type_id,
    work_type_name,
    case   
        when lower(work_type_id) like '%service%' then 'Service'
        when lower(work_type_id) like '%deliver%' then 'Pick & Drop'
        when lower(work_type_id) like '%remove%' then 'Pick & Drop'
        else 'Others'
        end as work_type
from {{ref('raw_navusoft__work_order')}} a

