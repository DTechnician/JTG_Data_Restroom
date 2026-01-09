{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='accessory_device_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "account_and_site",
    natural_key = ["site_division_id"],
    attributes = [
        "site_division_name"
    ],
    scd_type = 2
) }}