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
    natural_key = ["associate_oid"],
    attributes = [
        'job_title',
        'driver_name',
        'driver_last_name',
        'driver_given_name',
        'adp_driver_id',
        'navusoft_driver_id',
        'hourly_rate'
    ],
    scd_type = 2
) }}