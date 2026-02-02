{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

select distinct
    {{ generate_surrogate_key([
                'a.EQUIPMENTTYPE_ID' 
    ]) }} as equipment_type_sk ,
    EQUIPMENTTYPE_ID as equipment_type_id,
    EQUIPMENTTYPE_NAME as equipment_type_name,
from 
{{ref('stg_navusoft_site_service_history')}} a
