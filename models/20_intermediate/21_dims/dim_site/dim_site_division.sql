{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='site_division_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "site_division_sk",
    table_name = "account_and_site",
    natural_key = ["site_division_id"],
    attributes = [
        'site_division_name'
    ],
    dedupe_strategy = 'latest',
    scd_type = 2
) }}