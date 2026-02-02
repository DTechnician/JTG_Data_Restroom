{{ 
  generate_navusoft_staging(
    entity_name='v_query_active_services_tiered_pricing',
    unique_key='payload_hash',
    fields=[
{'name': 'charge_code_start_date', 'type': 'timestamp_ntz'},
{'name': 'charge_code_end_date', 'type': 'timestamp_ntz'},
{'name': 'siteservice_id', 'type': 'number'},
{'name': 'service_charge_id', 'type': 'number'},
{'name': 'service_charge_tiered_pricing_id', 'type': 'number'},
{'name': 'from_quantity', 'type': 'number'},
{'name': 'to_quantity', 'type': 'number'},
{'name': 'rate', 'type': 'number'},
{'name': 'site_id', 'type': 'number'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'serviceregion_id', 'type': 'number'},
{'name': 'serviceregion_name', 'type': 'varchar'},
{'name': 'servicecode_id', 'type': 'number'},
{'name': 'service_code_name', 'type': 'varchar'},
{'name': 'service_frequency', 'type': 'number'},
{'name': 'chargecode_id', 'type': 'number'},
{'name': 'charge_code_name', 'type': 'varchar'},
{'name': 'dot_description', 'type': 'varchar'},
{'name': 'materialtype_id', 'type': 'number'},
{'name': 'materialtype', 'type': 'varchar'},
{'name': 'equipmentype_id', 'type': 'number'},
{'name': 'equipmentype_name', 'type': 'varchar'},
{'name': 'type', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> 4f71943348097e08bf897c819f49b561526606bd
