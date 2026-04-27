{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='lob_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "lob_sk",
    table_name = "site_service_history",
    natural_key = ["lob_id"],
    attributes = [ 
		"lob_name"
    ],    
    dedupe_strategy = 'latest',
    scd_type = 2
) }}