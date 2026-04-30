{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='obd_engine_second_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "obd_engine_second",
    natural_key = ["vehicle_id", "time"],
    attributes = [
        "value",
    ],
    scd_type = 2
) }}