{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='trailer_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "trailer",
    natural_key = ["id"],
    attributes = [
        "enabled_for_mobile",
        "license_plate",
        "name",
        "notes",
        "trailer_serial_number",
        "external_id",
        "gateway_serial"
    ],
    scd_type = 2
) }}
