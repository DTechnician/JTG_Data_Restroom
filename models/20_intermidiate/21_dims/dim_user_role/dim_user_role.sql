{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='user_role_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "user_role",
    natural_key = ['users_id','index'],
    attributes = [
        "tag_id",
    ],
    scd_type = 2
) }}
