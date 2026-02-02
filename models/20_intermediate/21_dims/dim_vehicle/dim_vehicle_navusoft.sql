{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

select distinct
    {{ generate_surrogate_key([
                'a.truck_id' 
    ]) }} as vehicle_sk ,
    truck_id as vehicle_id,
    truck_name as vehicle_name,
from 
{{ref('raw_navusoft__work_order')}} a
