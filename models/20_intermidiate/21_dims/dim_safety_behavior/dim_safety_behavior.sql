{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='safety_behavior_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "safety_behavior",
    natural_key = ["label","safety_event_id"],
    attributes = [
        "name",
        "source"
    ],
    scd_type = 2
) }}
