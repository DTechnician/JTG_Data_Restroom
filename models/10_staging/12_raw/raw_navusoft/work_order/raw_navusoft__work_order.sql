{{ 
  generate_navusoft_staging(
    entity_name='v_query_workorder',
    unique_key='workordernumber',
    fields=[
<<<<<<< HEAD
        {'name': 'access_information', 'type': 'STRING'},
        {'name': 'account_id', 'type': 'NUMBER'},
        {'name': 'address_line_1', 'type': 'STRING'},
        {'name': 'address_line_2', 'type': 'STRING'},
        {'name': 'billed_period', 'type': 'STRING'},

        {'name': 'calculated_end_timestamp', 'type': 'TIMESTAMP_NTZ'},
        {'name': 'calculated_start_timestamp', 'type': 'TIMESTAMP_NTZ'},

        {'name': 'city', 'type': 'STRING'},

        {'name': 'completion_date', 'type': 'DATE'},
        {'name': 'completion_note', 'type': 'STRING'},
        {'name': 'completiondatetime', 'type': 'TIMESTAMP_NTZ'},

        {'name': 'contact_email', 'type': 'STRING'},
        {'name': 'contact_id', 'type': 'NUMBER'},
        {'name': 'contact_name', 'type': 'STRING'},
        {'name': 'contact_phone1', 'type': 'STRING'},

        {'name': 'created_by_user', 'type': 'STRING'},
        {'name': 'createdtimestamp', 'type': 'TIMESTAMP_NTZ'},

        {'name': 'disposal_cost', 'type': 'FLOAT'},
        {'name': 'disposal_costs', 'type': 'FLOAT'},
        {'name': 'disposal_facility_name', 'type': 'STRING'},
        {'name': 'disposal_quantity', 'type': 'FLOAT'},

        {'name': 'division_id', 'type': 'NUMBER'},

        {'name': 'driver_id', 'type': 'NUMBER'},
        {'name': 'driver_name', 'type': 'STRING'},

        {'name': 'end_timestamp_override', 'type': 'TIMESTAMP_NTZ'},

        {'name': 'equipment_type_id', 'type': 'STRING'},
        {'name': 'equipment_type_name', 'type': 'STRING'},
        {'name': 'equipment_volume', 'type': 'NUMBER'},

        {'name': 'exception_reason_code', 'type': 'STRING'},
        {'name': 'exception_reason_name', 'type': 'STRING'},

        {'name': 'geofence_end_time_stamp', 'type': 'TIMESTAMP_NTZ'},
        {'name': 'geofence_start_time_stamp', 'type': 'TIMESTAMP_NTZ'},

        {'name': 'id', 'type': 'NUMBER'},

        {'name': 'lob_id', 'type': 'STRING'},

        {'name': 'material_type_id', 'type': 'STRING'},
        {'name': 'material_type_name', 'type': 'STRING'},

        {'name': 'minutes', 'type': 'NUMBER'},

        {'name': 'note', 'type': 'STRING'},

        {'name': 'oncall_reason_code', 'type': 'STRING'},
        {'name': 'oncall_reason_name', 'type': 'STRING'},

        {'name': 'opmitizationexpectedservicetime', 'type': 'NUMBER'},
        {'name': 'optimizationdistance', 'type': 'FLOAT'},
        {'name': 'optimizationexpectedstarttime', 'type': 'TIMESTAMP_NTZ'},
        {'name': 'optimizationtraveltime', 'type': 'NUMBER'},

        {'name': 'order_note', 'type': 'STRING'},
        {'name': 'order_type', 'type': 'STRING'},

        {'name': 'original_scheduled_date', 'type': 'DATE'},
        {'name': 'posted_date', 'type': 'DATE'},

        {'name': 'posted_status_name', 'type': 'STRING'},
        {'name': 'posted_user_id', 'type': 'NUMBER'},
        {'name': 'posted_user_name', 'type': 'STRING'},
        {'name': 'posting_status', 'type': 'NUMBER'},

        {'name': 'profit', 'type': 'FLOAT'},

        {'name': 'quantity', 'type': 'NUMBER'},

        {'name': 'requested_by', 'type': 'STRING'},

        {'name': 'revenue', 'type': 'FLOAT'},

        {'name': 'route_default_disposallocation_id', 'type': 'NUMBER'},
        {'name': 'route_default_disposallocation_name', 'type': 'STRING'},

        {'name': 'route_external_id', 'type': 'STRING'},
        {'name': 'route_id', 'type': 'NUMBER'},
        {'name': 'route_name', 'type': 'STRING'},

        {'name': 'scheduled_date', 'type': 'DATE'},

        {'name': 'sequence', 'type': 'NUMBER'},

        {'name': 'service_cost', 'type': 'FLOAT'},
        {'name': 'service_note', 'type': 'STRING'},
        {'name': 'service_record_external_id', 'type': 'STRING'},

        {'name': 'service_region_name', 'type': 'STRING'},
        {'name': 'servicecode_id', 'type': 'STRING'},
        {'name': 'servicecode_name', 'type': 'STRING'},
        {'name': 'serviceregion_id', 'type': 'STRING'},

        {'name': 'site_id', 'type': 'NUMBER'},
        {'name': 'site_name', 'type': 'STRING'},
        {'name': 'siteservice_id', 'type': 'NUMBER'},

        {'name': 'start_timestamp_override', 'type': 'TIMESTAMP_NTZ'},

        {'name': 'state', 'type': 'STRING'},

        {'name': 'status', 'type': 'NUMBER'},
        {'name': 'status_in_progress_timestamp', 'type': 'TIMESTAMP_NTZ'},
        {'name': 'status_text', 'type': 'STRING'},

        {'name': 'surcharge_revenue', 'type': 'FLOAT'},

        {'name': 'total_cost', 'type': 'FLOAT'},
        {'name': 'total_revenue', 'type': 'FLOAT'},

        {'name': 'truck_id', 'type': 'NUMBER'},
        {'name': 'truck_name', 'type': 'STRING'},

        {'name': 'wominimumchargeamount', 'type': 'FLOAT'},
        {'name': 'work_order_weight', 'type': 'FLOAT'},

        {'name': 'work_period', 'type': 'STRING'},

        {'name': 'work_type_id', 'type': 'STRING'},
        {'name': 'work_type_name', 'type': 'STRING'},

        {'name': 'workorder_po_number', 'type': 'STRING'},
        {'name': 'workorder_revenue', 'type': 'FLOAT'},
        {'name': 'workordernumber', 'type': 'NUMBER'},

        {'name': 'zip', 'type': 'STRING'}


    ]
  )
}}
=======
        {'name': 'workordernumber', 'type': 'number'},
        {'name': 'site_id', 'type': 'number'},
        {'name': 'division_id', 'type': 'number'},
        {'name': 'account_id', 'type': 'number'},
        {'name': 'route_id', 'type': 'number'},
        {'name': 'route_default_disposallocation_id', 'type': 'number'},
        {'name': 'truck_id', 'type': 'number'},
        {'name': 'driver_id', 'type': 'number'},
        {'name': 'posted_user_id', 'type': 'number'},
        {'name': 'contact_id', 'type': 'number'},
        {'name': 'lob_id', 'type': 'varchar'},

        {'name': 'scheduled_date', 'type': 'timestamp_ntz'},
        {'name': 'posted_date', 'type': 'timestamp_ntz'},
        {'name': 'completion_date', 'type': 'timestamp_ntz'},
        {'name': 'createdtimestamp', 'type': 'timestamp_ntz'},
        
        {'name': 'status', 'type': 'number'},
        {'name': 'posting_status', 'type': 'number'},
        {'name': 'quantity', 'type': 'number'},
        {'name': 'sequence', 'type': 'number'},
        {'name': 'optimizationtraveltime', 'type': 'number'},
        {'name': 'minutes', 'type': 'number'},
        {'name': 'disposal_quantity', 'type': 'number'},
        {'name': 'optimizationdistance', 'type': 'number'},
        {'name': 'work_order_weight', 'type': 'number'},
        {'name': 'wominimumchargeamount', 'type': 'number'},
        {'name': 'workorder_revenue', 'type': 'number'},
        {'name': 'equipment_volume', 'type': 'number'},

          
        {'name': 'disposal_costs' , 'type': 'numeric(12,4)'},
        {'name': 'revenue' , 'type': 'numeric(12,4)'},
        {'name': 'surcharge_revenue' , 'type': 'numeric(12,4)'},
        {'name': 'total_revenue' , 'type': 'numeric(12,4)'},
        {'name': 'service_cost' , 'type': 'numeric(12,4)'},
        {'name': 'disposal_cost' , 'type': 'numeric(12,4)'},
        {'name': 'total_cost' , 'type': 'numeric(12,4)'},
        {'name': 'profit' , 'type': 'numeric(12,4)'},

    ]
  )
}}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
