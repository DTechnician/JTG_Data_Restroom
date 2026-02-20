{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='lob_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

select distinct
    {{ generate_surrogate_key([
                'a.lob_id' 
    ]) }} as lob_sk ,
    lob_id,
    lob_name,
from 
{{ref('raw_navusoft__site_service_history')}} a
