{{ config(
    materialized='incremental',
    tags=['dims'],
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

        "service_code_id",
        "lob_id",
        "equipmenttype_id",
        "site_id",
        "lost_to_competitor_id",

        "site_division_id",
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
    foreign_keys = [
        {
            'name': 'site_sk',
            'dim_model': 'dim_site',
            'dim_sk': 'site_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'site_id', 'dim': 'site_id'}
            ]
        },
        {
            'name': 'service_code_sk',
            'dim_model': 'dim_service_code',
            'dim_sk': 'service_code_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'service_code_id', 'dim': 'service_code_id'}
            ]
        },
        {
            'name': 'equipment_type_sk',
            'dim_model': 'dim_equipment_type',
            'dim_sk': 'equipment_type_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'equipmenttype_id', 'dim': 'equipment_type_id'}
            ]
        },
        {
            'name': 'lob_sk',
            'dim_model': 'dim_line_of_business',
            'dim_sk': 'lob_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'lob_id', 'dim': 'lob_id'}
            ]
        }
        
    ],
    
    scd_type = 2
) }}    