{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='deparment_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "prep",
    table_name = "department",
    natural_key = ["department_code"],
    attributes = [
        'department_name',
        'location',
        'function'
    ],
    scd_type = 2
) }}