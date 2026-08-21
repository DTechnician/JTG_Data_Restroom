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
        'business_unit_code',
        'business_unit_name',
        'sub_department_code',
        'worker_name',
        'worker_last_name',
        'worker_given_name',
        'adp_worker_id',
        'navusoft_driver_id',
        'hourly_rate',
        'overtime_hourly_rate',
    ],
    foreign_keys = [
        {
            'name': 'sub_department_sk',
            'dim_model': 'dim_sub_department',
            'dim_sk': 'sub_department_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'sub_department_code', 'dim': 'sub_department_code'}
            ]
        },
    ],
    scd_type = 2
) }}