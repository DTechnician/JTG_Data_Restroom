{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "prep",
    table_name = "driver",
    natural_key = ["driver_map_name"],
    attributes = [
        'samsara_driver_id',
        'samsara_driver_name',
        'navusoft_driver_id',
        'navusoft_driver_name',
        'adp_driver_id',
        'adp_hourly_rate',
        'adp_associate_id'
    ],
    scd_type = 2
) }}