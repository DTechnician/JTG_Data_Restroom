{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='site_service_history_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}
--"lob_name", --to be removed once downstream model is revisited
{{ generate_dimension(
    source = "navusoft",
    table_name = "site_service_history",
    natural_key = ["service_id"],
    attributes = [

        "start_date",
        "end_date",
        "billed_thru_date",

        "site_division_id",
        "service_code_id",
        "lob_id",
        "equipmenttype_id",
        "lost_to_competitor_id",
        "site_id",

        "lob_name",
        "equipmenttype_name",

        "start_posted_timestamp",
        "end_posted_timestamp",
        "start_reason_code",
        "end_reason_code",
        "start_user_name",
        "end_user_name",


        "perunitrate",
        "rate",
        "quantity",
        "service_frequency"
    ],
    
    scd_type = 2
) }}    