{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='gateway_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "gateway",
    natural_key = ["id"],
    attributes = [
        "serial",
        "model",
        "connection_status_health_status",
        "thirty_day_data_usage_bytes",
        "thirty_day_hotspot_usage_bytes",
        "connection_status_last_connected"
    ],
    scd_type = 2
) }}
