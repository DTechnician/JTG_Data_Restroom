{{ 
  generate_navusoft_staging(
    entity_name='v_query_cancellation_request',
    unique_key='payload_hash',
    fields=[
{'name': 'cancellation_effectivedate', 'type': 'timestamp_ntz'},
{'name': 'contract_start_date', 'type': 'timestamp_ntz'},
{'name': 'target_resolution_date', 'type': 'timestamp_ntz'},
{'name': 'account_id', 'type': 'number'},
{'name': 'cancellation_status_id', 'type': 'number'},
{'name': 'Cancellation_CreatedDate', 'type': 'timestamp_ntz'},
{'name': 'average_monthly_revenue', 'type': 'number'},
{'name': 'site_id', 'type': 'number'},
{'name': 'account_name', 'type': 'varchar'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'site_serviceregion', 'type': 'varchar'},
{'name': 'site_salesrep', 'type': 'varchar'},
{'name': 'account_status', 'type': 'varchar'},
{'name': 'account_manager', 'type': 'varchar'},
{'name': 'site_status', 'type': 'varchar'},
{'name': 'createdby_user', 'type': 'varchar'},
{'name': 'cancellation_status_text', 'type': 'varchar'},
{'name': 'reasoncode_name', 'type': 'varchar'},
{'name': 'cancellation_note', 'type': 'varchar'},
{'name': 'cancellation_contact', 'type': 'varchar'},
{'name': 'requested_by', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> 4f71943348097e08bf897c819f49b561526606bd
