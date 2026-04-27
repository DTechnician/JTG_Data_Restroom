{{ 
  generate_navusoft_staging(
    entity_name='v_query_tax_details',
    unique_key='payload_hash',
    fields=[
{'name': 'taxexempt', 'type': 'numeric(10,2)'},
{'name': 'divisionId', 'type': 'number'},
{'name': 'accountId', 'type': 'number'},
{'name': 'invoiceId', 'type': 'number'},
{'name': 'totalsales', 'type': 'numeric(10,2)'},
{'name': 'taxablerevenue', 'type': 'numeric(10,2)'},
{'name': 'taxes', 'type': 'numeric(10,2)'},
{'name': 'siteId', 'type': 'number'},
{'name': 'divisionname', 'type': 'varchar'},
{'name': 'accountname', 'type': 'varchar'},
{'name': 'sitename', 'type': 'varchar'},
{'name': 'addressline1', 'type': 'varchar'},
{'name': 'addressline2', 'type': 'varchar'},
{'name': 'city', 'type': 'varchar'},
{'name': 'state', 'type': 'varchar'},
{'name': 'taxregionId', 'type': 'varchar'},
{'name': 'period_id', 'type': 'varchar'},
{'name': 'tax_name', 'type': 'varchar'},
{'name': 'tax_authority_code', 'type': 'varchar'},
{'name': 'tax_authority_type_name', 'type': 'varchar'},
{'name': 'creditglaccount_id', 'type': 'varchar'},
{'name': 'debitglaccount_id', 'type': 'varchar'},
{'name': 'lob_id', 'type': 'varchar'},
{'name': 'lob_name', 'type': 'varchar'},

    ]
  )
}}