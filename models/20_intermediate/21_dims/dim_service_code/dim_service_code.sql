{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='service_code_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "service_code_sk",
    table_name = "site_service_history",
    natural_key = ["SERVICE_CODE_ID"],
    attributes = [ 
		"SERVICE_CODE_NAME"
    ],    
    dedupe_strategy = 'latest',
    scd_type = 2
) }}