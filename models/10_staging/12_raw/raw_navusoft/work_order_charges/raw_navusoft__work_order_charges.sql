{{ 
  generate_navusoft_staging(
    entity_name='v_query_workordercharges',
    unique_key='payload_hash',
    fields=[
{'name': 'date', 'type': 'timestamp_ntz'},
{'name': 'weightcharge', 'type': 'number'},
{'name': 'is_manifested', 'type': 'varchar'},
{'name': 'servicerecordcharge_id', 'type': 'number'},
{'name': 'servicerecord_id', 'type': 'number'},
{'name': 'workordernumber', 'type': 'number'},
{'name': 'division_id', 'type': 'number'},
{'name': 'manifestconsolidationbatch_id', 'type': 'number'},
{'name': 'grossquantity', 'type': 'numeric(10,2)'},
{'name': 'nochargequantity', 'type': 'numeric(10,2)'},
{'name': 'perunitrate', 'type': 'numeric(10,2)'},
{'name': 'quantity', 'type': 'numeric(10,2)'},
{'name': 'weight', 'type': 'numeric(10,2)'},
{'name': 'originalweight', 'type': 'numeric(10,2)'},
{'name': 'volume', 'type': 'numeric(10,2)'},
{'name': 'netvolume', 'type': 'numeric(10,2)'},
{'name': 'netweight', 'type': 'numeric(10,2)'},
{'name': 'mincharge', 'type': 'numeric(10,2)'},
{'name': 'amount', 'type': 'numeric(10,2)'},
{'name': 'site_id', 'type': 'number'},
{'name': 'worktype_id', 'type': 'varchar'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'serviceregion_id', 'type': 'varchar'},
{'name': 'serviceregion_name', 'type': 'varchar'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'chargecode_id', 'type': 'varchar'},
{'name': 'chargecode', 'type': 'varchar'},
{'name': 'dotdescription', 'type': 'varchar'},
{'name': 'materialtype_id', 'type': 'number'},
{'name': 'materialtype', 'type': 'varchar'},
{'name': 'equipmentype_id', 'type': 'number'},
{'name': 'equipmentype_name', 'type': 'varchar'},
{'name': 'unit', 'type': 'varchar'},
{'name': 'charge_abbreviation', 'type': 'varchar'},
{'name': 'equipmenttype_abbreviation', 'type': 'varchar'},
{'name': 'weight_oum', 'type': 'varchar'},
{'name': 'rate_uom', 'type': 'varchar'},
{'name': 'transfertext', 'type': 'varchar'},
{'name': 'epawastecode_abbreviation', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> 4f71943348097e08bf897c819f49b561526606bd
