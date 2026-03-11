{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='site_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "site_sk",
    table_name = "account_and_site",
    natural_key = ["site_id"],
    attributes = [ 
        "site_address_line_1",
        "site_address_line_2",
        "site_city",
        "site_state_id",
        "site_state",
        "site_zip",
        "site_county",
        "site_division_id",
        "site_serviceregion_id",
        "site_service_region_name",

        "site_name",
        "site_name_2",
        "site_phone_1",
        "site_phone_2",
        "site_ponumber",
        "site_accessinformation",
        "site_businesshours",
        "site_old_id",
        "site_taxexempt_id",
        "site_taxexemptreason",
        "site_broker_id",
        "site_broker_name",
        "site_surchargegroup_id",
        "site_surchargegroup_name",
        "site_class_id",
        "site_class_name",
        "site_bill_to_selection",
        "site_billgroup_id",
        "site_billgroup_name",
        "site_tax_region_id",
        "site_taxregion_name",
        "site_warningnote",
        "site_epa_id",

        "site_generator_type_id",
        "site_generator_type_name",
        "site_source_id",
        "site_source_name",
        "site_salesrep_id",
        "site_salesrep_name",
        "site_created_by_user",
        "site_created_timestamp",
        "site_status_effective_date",
        "site_status",
        "site_status_text",
    ],
    foreign_keys = [
        {
            'name': 'site_division_sk',
            'dim_model': 'dim_site_division',
            'dim_sk': 'site_division_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'site_division_id', 'dim': 'site_division_id'}
            ]
        },
    ],
    scd_type = 2
) }}