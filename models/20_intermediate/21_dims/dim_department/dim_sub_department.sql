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

    foreign_keys = [
        {
            'name': 'department_sk',
            'dim_model': 'dim_department',
            'dim_sk': 'department_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'sub_department_code', 'dim': 'sub_department_code'}
            ]
        },
    ],
    scd_type = 2
) }}