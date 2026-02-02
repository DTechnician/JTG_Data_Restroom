{{ 
  generate_navusoft_staging(
    entity_name='v_query_currentaging',
    unique_key='payload_hash',
    fields=[
{'name': 'lastcollectionsactivity', 'type': 'varchar'},
{'name': 'lastpayment', 'type': 'varchar'},
{'name': 'account_status', 'type': 'varchar'},
{'name': 'division_id', 'type': 'number'},
{'name': 'account_id', 'type': 'number'},
{'name': 'average_days_to_pay', 'type': 'number'},
{'name': 'unappliedamount', 'type': 'numeric(10,2)'},
{'name': 'current_amount', 'type': 'number'},
{'name': 'oneto30amount', 'type': 'numeric(10,2)'},
{'name': 'thirtyoneto60amount', 'type': 'numeric(10,2)'},
{'name': 'sixtyoneto90amount', 'type': 'numeric(10,2)'},
{'name': 'ninetyoneto120amount', 'type': 'numeric(10,2)'},
{'name': 'over120amount', 'type': 'numeric(10,2)'},
{'name': 'total', 'type': 'numeric(10,2)'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'account_name', 'type': 'varchar'},
{'name': 'account_status_text', 'type': 'varchar'},
{'name': 'auditor_name', 'type': 'varchar'},
{'name': 'billgroup_id', 'type': 'varchar'},
{'name': 'billgroup_name', 'type': 'varchar'},

    ]
  )
}}