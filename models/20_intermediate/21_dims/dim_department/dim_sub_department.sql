{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='sub_department_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "prep",
    table_name = "sub_department",
    natural_key = ["sub_department_code"],
    attributes = [
        "sub_department_name"
    ],
    scd_type = 2
) }}