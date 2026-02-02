{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

select distinct
    {{ generate_surrogate_key([
                'a.SERVICE_CODE_ID' 
    ]) }} as service_code_sk ,
    SERVICE_CODE_ID,
    SERVICE_CODE_NAME,
from 
{{ref('stg_navusoft_site_service_history')}} a
