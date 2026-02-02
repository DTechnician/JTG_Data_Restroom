{{ 
  generate_navusoft_staging(
    entity_name='v_query_siteservicehistory',
    unique_key='payload_hash',
    fields=[
{'name': 'start_date', 'type': 'timestamp_ntz'},
{'name': 'end_date', 'type': 'timestamp_ntz'},
{'name': 'billed_thru_date', 'type': 'timestamp_ntz'},
{'name': 'site_division_id', 'type': 'number'},
{'name': 'service_id', 'type': 'number'},
{'name': 'start_posted_timestamp', 'type': 'timestamp_ntz'},
{'name': 'end_posted_timestamp', 'type': 'timestamp_ntz'},
{'name': 'quantity', 'type': 'number'},
{'name': 'perunitrate', 'type': 'numeric(10,2)'},
{'name': 'rate', 'type': 'numeric(10,2)'},
{'name': 'site_id', 'type': 'number'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'site_address_line_1', 'type': 'varchar'},
{'name': 'site_address_line_2', 'type': 'varchar'},
{'name': 'site_city', 'type': 'varchar'},
{'name': 'site_state', 'type': 'varchar'},
{'name': 'site_zip', 'type': 'varchar'},
{'name': 'start_reason_code', 'type': 'varchar'},
{'name': 'start_user_name', 'type': 'varchar'},
{'name': 'end_reason_code', 'type': 'varchar'},
{'name': 'end_user_name', 'type': 'varchar'},
{'name': 'service_code_id', 'type': 'varchar'},
{'name': 'service_code_name', 'type': 'varchar'},
{'name': 'lob_id', 'type': 'varchar'},
{'name': 'lob_name', 'type': 'varchar'},
{'name': 'equipmenttype_id', 'type': 'varchar'},
{'name': 'equipmenttype_name', 'type': 'varchar'},
{'name': 'service_frequency', 'type': 'varchar'},
{'name': 'lost_to_competitor_id', 'type': 'varchar'},
{'name': 'lost_to_competitor_name', 'type': 'varchar'},

    ]
  )
}}
