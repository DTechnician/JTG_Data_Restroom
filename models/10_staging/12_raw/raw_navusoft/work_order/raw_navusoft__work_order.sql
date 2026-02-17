{{ 
  generate_navusoft_staging(
    entity_name='v_query_workorder',
    unique_key='workordernumber',
    fields=[
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