{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='tag_address_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "tag_address",
    natural_key = ["address_id","index"],
    attributes = [
        "tag_id"
    ],
    scd_type = 2
) }}
