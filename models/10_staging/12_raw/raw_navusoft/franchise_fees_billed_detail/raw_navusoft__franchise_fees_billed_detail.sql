{{ 
  generate_navusoft_staging(
    entity_name='v_query_franchise_fees_billed_detail',
    unique_key='payload_hash',
    fields=[
{'name': 'date', 'type': 'timestamp_ntz'},
{'name': 'fromdate', 'type': 'timestamp_ntz'},
{'name': 'todate', 'type': 'timestamp_ntz'},
{'name': 'id', 'type': 'number'},
{'name': 'division_id', 'type': 'number'},
{'name': 'number_of_pickups', 'type': 'number'},
{'name': 'invoice_id', 'type': 'number'},
{'name': 'account_id', 'type': 'number'},
{'name': 'billingbatch_id', 'type': 'number'},
{'name': 'wonumber', 'type': 'number'},
{'name': 'quantity', 'type': 'number'},
{'name': 'perunitrate', 'type': 'number'},
{'name': 'amount', 'type': 'numeric(10,2)'},
{'name': 'surcharge_amount', 'type': 'numeric(10,2)'},
{'name': 'site_id', 'type': 'number'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'postingperiod_id', 'type': 'varchar'},
{'name': 'equipmenttype_id', 'type': 'varchar'},
{'name': 'equipment', 'type': 'varchar'},
{'name': 'code', 'type': 'varchar'},
{'name': 'servicedescription', 'type': 'varchar'},
{'name': 'svcfrequency', 'type': 'varchar'},
{'name': 'material', 'type': 'varchar'},
{'name': 'ponumber', 'type': 'varchar'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'addressline1', 'type': 'varchar'},
{'name': 'city', 'type': 'varchar'},
{'name': 'state', 'type': 'varchar'},
{'name': 'postalcode', 'type': 'varchar'},
{'name': 'county', 'type': 'varchar'},
{'name': 'phone1', 'type': 'varchar'},
{'name': 'surcharge_name', 'type': 'varchar'},
{'name': 'surcharge_id', 'type': 'varchar'},
{'name': 'routing_days', 'type': 'number'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
