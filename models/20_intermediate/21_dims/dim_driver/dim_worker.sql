{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='worker_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "prep",
    table_name = "worker",
    natural_key = ["associate_oid"],
    attributes = [
        'job_title',
        'worker_name',
        'worker_last_name',
        'worker_given_name',
        'adp_worker_id',
        'navusoft_driver_id',
        'hourly_rate',
        'overtime_hourly_rate',
    ],
    scd_type = 2
) }}