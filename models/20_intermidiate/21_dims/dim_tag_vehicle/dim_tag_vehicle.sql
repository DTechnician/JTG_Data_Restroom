{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='tag_vehicle_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "tag_vehicle",
    natural_key = ["vehicle_id","index"],
    attributes = [
        "tag_id"
    ],
    scd_type = 2
) }}
