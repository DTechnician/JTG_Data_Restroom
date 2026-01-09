{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='tag_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "tags",
    natural_key = ["id"],
    attributes = [
        "name",
        "external_id",
        "parent_tag_id"
    ],
    scd_type = 2
) }}
