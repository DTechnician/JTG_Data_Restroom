{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='account_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "account_and_site",
    natural_key = ["account_id"],
    attributes = [ 
        "account_name",
        "account_name_2",
        "account_phone",
        "account_credit_limit",
        "account_old_id",
        "account_source_id",

        "account_manager_id",
        "account_manager_name",

        "parentaccount_id",

        "account_class_id",
        "account_class_name",
        
        "account_division_id",
        "account_term_id",
        "account_status",
        "account_billgroup_id",
        "account_brokergroup_id",
        "account_created_timestamp",
        "account_created_by_user"
    ],
    scd_type = 2
) }}