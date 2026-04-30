{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "driver_sk",
    table_name = "work_order",
    natural_key = ["driver_id"],
    attributes = [
        'driver_name'
    ],
    dedupe_strategy = 'latest',
    scd_type = 2
) }}