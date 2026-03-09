{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='work_order_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source          = 'navusoft',
    table_name      = 'work_order',
    natural_key     = ['workordernumber'],
    attributes = [
		"account_id",
        "contact_id",
        "driver_id",
        "equipment_type_id",
        "exception_reason_code",
        "lob_id",
        "material_type_id",
        "posted_status_name",
        "route_id",
        "servicecode_id",
        "serviceregion_id",
        "site_id",
        "siteservice_id",
        "status",
        "truck_id",
        "work_type_id",

        "scheduled_date",
        "completion_date",

        "quantity"
	],
    derived_attributes = [
        { 'name': 'missed_services',  'expr': "case  when status_text not in ('Cancelled','Service Completed') then quantity else null end" }
    ],
    foreign_keys = [
        {
            'name': 'account_sk',
            'dim_model': 'dim_account',
            'dim_sk': 'account_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'account_id', 'dim': 'account_id'}
            ]
        },
        {
            'name': 'scheduled_date_sk',
            'dim_model': 'dim_date',
            'dim_sk': 'date_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'scheduled_date', 'dim': 'date'}
            ]
        },
        {
            'name': 'completion_date_sk',
            'dim_model': 'dim_date',
            'dim_sk': 'date_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'completion_date', 'dim': 'date'}
            ]
        },
        {
            'name': 'site_service_history_sk',
            'dim_model': 'dim_site_service_history',
            'dim_sk': 'site_service_history_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'siteservice_id', 'dim': 'service_id'}
            ]
        }
    ],
    scd_type = 2
) }}