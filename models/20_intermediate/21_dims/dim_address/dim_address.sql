{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='address_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "address",
    natural_key = ["id"],
    attributes = [
        "settings_show_address",
        "external_id",
        "longitude",
        "latitude",
        "name",
        "type",
        "notes"
    ],
    scd_type = 2
) }}