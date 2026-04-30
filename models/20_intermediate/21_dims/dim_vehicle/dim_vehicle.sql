{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='vehicle_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "prep",
    table_name = "vehicle",
    natural_key = ["vehicle_map_name"],
    attributes = [
        'samsara_vehicle_id',
        'samsara_vehicle_name',
        'navusoft_vehicle_id',
        'navusoft_vehicle_name'
    ],
    scd_type = 2
) }}