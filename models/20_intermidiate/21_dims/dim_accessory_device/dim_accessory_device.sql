{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='accessory_device_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "accessory_device",
    natural_key = ["serial"],
    attributes = [
        "model",
        "gateway_id"
    ],
    scd_type = 2
) }}
