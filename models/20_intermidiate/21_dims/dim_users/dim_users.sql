{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='users_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "users",
    natural_key = ["id"],
    attributes = [
        "auth_type",
        "email",
        "name"
    ],
    scd_type = 2
) }}
