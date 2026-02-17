{{ 
  generate_navusoft_staging(
    entity_name='v_query_workorder_label',
    unique_key='payload_hash',
    fields=[
{'name': 'manualentry', 'type': 'varchar'},
{'name': 'servicerecord_id', 'type': 'number'},
{'name': 'workordernumber', 'type': 'number'},
{'name': 'id', 'type': 'number'},
{'name': 'servicerecordcharge_id', 'type': 'number'},
{'name': 'manifestconsolidationbatch_id', 'type': 'number'},
{'name': 'uom_id', 'type': 'number'},
{'name': 'disposallocation_id', 'type': 'number'},
{'name': 'receipttimestamp', 'type': 'timestamp_ntz'},
{'name': 'tareweight', 'type': 'numeric(10,2)'},
{'name': 'grossweight', 'type': 'numeric(10,2)'},
{'name': 'netweight', 'type': 'numeric(10,2)'},
{'name': 'chargecode_id', 'type': 'number'},
{'name': 'scanneduser_name', 'type': 'varchar'},
{'name': 'label', 'type': 'varchar'},
{'name': 'exceptionreasoncode_id', 'type': 'number'},
{'name': 'uom_name', 'type': 'varchar'},
{'name': 'disposallocation_name', 'type': 'varchar'},
{'name': 'equipmenttype_id', 'type': 'number'},
{'name': 'equipmenttype_name', 'type': 'varchar'},
{'name': 'materialtype_id', 'type': 'number'},
{'name': 'materialtype_name', 'type': 'varchar'},
{'name': 'exception_approved', 'type': 'varchar'},
{'name': 'exception_approved_user', 'type': 'varchar'},

    ]
  )
}}