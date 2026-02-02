{{ 
  generate_navusoft_staging(
    entity_name='v_query_billbatchsummary',
    unique_key='payload_hash',
    fields=[
{'name': 'billing_date', 'type': 'timestamp_ntz'},
{'name': 'billing_from_date', 'type': 'timestamp_ntz'},
{'name': 'billing_to_date', 'type': 'timestamp_ntz'},
{'name': 'billing_batch_id', 'type': 'number'},
{'name': 'division_id', 'type': 'number'},
{'name': 'invoice_count', 'type': 'number'},
{'name': 'printable_count', 'type': 'number'},
{'name': 'eligible_for_email_count', 'type': 'number'},
{'name': 'autopay_enrolled_count', 'type': 'number'},
{'name': 'billing_batch_created_timestamp', 'type': 'timestamp_ntz'},
{'name': 'billing_batch_completed_timestamp', 'type': 'timestamp_ntz'},
{'name': 'billingbatch_amount', 'type': 'number'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'bill_group_id', 'type': 'varchar'},
{'name': 'bill_group_name', 'type': 'varchar'},
{'name': 'billing_batch_type', 'type': 'varchar'},
{'name': 'billing_batch_status', 'type': 'varchar'},
{'name': '"Created by User"', 'type': 'varchar'},
{'name': '"Completd by User"', 'type': 'varchar'},

    ]
  )
}}
