{{ 
  generate_navusoft_staging(
    entity_name='v_query_active_services',
    unique_key='siteservice_id',
    fields=[
        {'name': 'siteservice_id', 'type': 'number'},
        {'name': 'site_id', 'type': 'number'},
        {'name': 'vendor_site_id', 'type': 'number'},
        {'name': 'division_id', 'type': 'number'},
        {'name': 'serviceregion_id', 'type': 'varchar'},
        {'name': 'equipmenttype_id', 'type': 'varchar'},
        {'name': 'lob_id', 'type': 'varchar'},
        {'name': 'materialtype_id', 'type': 'varchar'},
        {'name': 'servicecode_id', 'type': 'varchar'},
        {'name': 'default_destination_id', 'type': 'number'},
        {'name': 'reasoncode_id', 'type': 'varchar'},
        {'name': 'inactivity_rental_free_days', 'type': 'number'},
        {'name': 'quantity', 'type': 'number'},
        {'name': 'equipment_size', 'type': 'number'},
        {'name': 'rate', 'type': 'number'},
        {'name': 'workorderminimum', 'type': 'number'},
        {'name': 'vendor_rate', 'type': 'number'},
        {'name': 'rate_per_yard', 'type': 'numeric(10,2)'},
        {'name': 'inactivity_rental_rate', 'type': 'number'},
        {'name': 'startdate', 'type': 'timestamp_ntz'},
        {'name': 'enddate', 'type': 'timestamp_ntz'},
        {'name': 'billed_through_date', 'type': 'timestamp_ntz'},
        {'name': 'division_name', 'type': 'varchar'},
        {'name': 'site_name', 'type': 'varchar'},
        {'name': 'addressline1', 'type': 'varchar'},
        {'name': 'city', 'type': 'varchar'},
        {'name': 'state', 'type': 'varchar'},
        {'name': 'postalcode', 'type': 'varchar'},
        {'name': 'serviceregionname', 'type': 'varchar'},
        {'name': 'lob_name', 'type': 'varchar'},
        {'name': 'eqquipmenttype_name', 'type': 'varchar'},
        {'name': 'materialname', 'type': 'varchar'},
        {'name': 'servicecodename', 'type': 'varchar'},
        {'name': 'service_frequency', 'type': 'varchar'},
        {'name': 'uom', 'type': 'varchar'},
        {'name': 'ownership', 'type': 'varchar'},
        {'name': 'vendor_name', 'type': 'varchar'},
        {'name': 'default_destination', 'type': 'varchar'},
        {'name': 'istemp', 'type': 'varchar'},
        {'name': 'routing_days', 'type': 'varchar'},
        {'name': 'route_names', 'type': 'varchar'},
        {'name': 'current_service_notes', 'type': 'varchar'},
    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> 4f71943348097e08bf897c819f49b561526606bd
