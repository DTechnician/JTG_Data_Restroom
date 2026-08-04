{{ config(
    materialized='incremental',
    tags=['dims'],
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
        "siteservice_id",
        "site_id",
        "servicecode_id",
        "equipment_type_id",
        "lob_id",
        "work_type_id",
        "route_id",
        "driver_id",
        "truck_id",

        "serviceregion_id",
        "contact_id",
        "material_type_id",

        "scheduled_date",
        "completion_date",

        "exception_reason_code",
        "posted_status_name",
        "status",
        "quantity"
	],
    derived_attributes = [
        { 'name': 'missed_services',  'expr': "case  when status in (0,1,2) or scheduled_date <> completion_date then quantity else null end" },
        { 'name': 'completed_services',  'expr': "case  when status in (3) then quantity else null end" },
        { 'name': 'calculated_timestamp_duration',  'expr': "datediff(minute ,calculated_start_timestamp, calculated_end_timestamp)" },
        { 'name': 'override_timestamp_duration',  'expr': "datediff(minute ,start_timestamp_override, end_timestamp_override)" },
        { 'name': 'geofence_timestamp_duration',  'expr': "datediff(minute ,geofence_start_time_stamp, geofence_start_time_stamp)" }
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
            'name': 'site_service_history_sk',
            'dim_model': 'dim_site_service_history',
            'dim_sk': 'site_service_history_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'siteservice_id', 'dim': 'service_id'}
            ]
        },
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
                {'src': 'servicecode_id', 'dim': 'service_code_id'}
            ]
        },
        {
            'name': 'equipment_type_sk',
            'dim_model': 'dim_equipment_type',
            'dim_sk': 'equipment_type_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'equipment_type_id', 'dim': 'equipment_type_id'}
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
        },
        {
            'name': 'work_type_sk',
            'dim_model': 'dim_work_type',
            'dim_sk': 'work_type_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'work_type_id', 'dim': 'work_type_id'}
            ]
        },
        {
            'name': 'route_sk',
            'dim_model': 'dim_route',
            'dim_sk': 'route_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'route_id', 'dim': 'route_id'}
            ]
        },
        {
            'name': 'worker_sk',
            'dim_model': 'dim_worker',
            'dim_sk': 'worker_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'driver_id', 'dim': 'navusoft_driver_id'}
            ]
        },
        {
            'name': 'vehicle_sk',
            'dim_model': 'bridge_navusoft__vehicle',
            'dim_sk': 'vehicle_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'truck_id', 'dim': 'navusoft_vehicle_id'}
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
        }
    ],
    scd_type = 2
) }}