{{ 
  generate_navusoft_staging(
    entity_name='v_query_active_services_charge_rates',
    unique_key='payload_hash',
    fields=[
{'name': 'startdate', 'type': 'date'},
{'name': 'minimum_charge_type', 'type': 'varchar'},
{'name': 'division_id', 'type': 'number'},
{'name': 'siteservice_id', 'type': 'number'},
{'name': 'rate', 'type': 'number'},
{'name': 'quantity', 'type': 'number'},
{'name': 'workorderminimum', 'type': 'number'},
{'name': 'mincharge', 'type': 'number'},
{'name': 'nochargequantity', 'type': 'number'},
{'name': 'site_id', 'type': 'number'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'addressline1', 'type': 'varchar'},
{'name': 'city', 'type': 'varchar'},
{'name': 'state', 'type': 'varchar'},
{'name': 'postalcode', 'type': 'varchar'},
{'name': 'serviceregion_id', 'type': 'varchar'},
{'name': 'serviceregionname', 'type': 'varchar'},
{'name': 'lob_id', 'type': 'varchar'},
{'name': 'lob_name', 'type': 'varchar'},
{'name': 'service_equipmenttype_id', 'type': 'varchar'},
{'name': 'service_equipmenttype_name', 'type': 'varchar'},
{'name': 'servicecode_id', 'type': 'varchar'},
{'name': 'servicecodename', 'type': 'varchar'},
{'name': 'chargecode_id', 'type': 'varchar'},
{'name': 'chargecodename', 'type': 'varchar'},
{'name': 'equipmenttype_id', 'type': 'varchar'},
{'name': 'equipmenttype_name', 'type': 'varchar'},
{'name': 'uom', 'type': 'varchar'},
{'name': 'chargecode_type', 'type': 'varchar'},


    ]
  )
}}
