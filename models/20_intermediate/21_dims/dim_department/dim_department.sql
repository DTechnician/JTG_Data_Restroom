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
    natural_key = ["department_name", "site_division_id", "sub_department_code"],
    attributes = [
        'site_division_name',
        'sub_department_name',
        'allocation_pct'
    ],
    scd_type = 2
) }}