{{ 
  generate_navusoft_staging(
    entity_name='v_query_site_contract_status',
    unique_key='payload_hash',
    fields=[
{'name': 'expirationdate', 'type': 'timestamp_ntz'},
{'name': 'contract_effective_date', 'type': 'timestamp_ntz'},
{'name': 'id', 'type': 'number'},
{'name': 'type_id', 'type': 'number'},
{'name': 'proposalformtype_id', 'type': 'number'},
{'name': 'division_id', 'type': 'number'},
{'name': 'salesrep_id', 'type': 'number'},
{'name': 'term', 'type': 'number'},
{'name': 'renewaltermmonths', 'type': 'number'},
{'name': 'rate_guarantee_months', 'type': 'number'},
{'name': 'estimatedmonthlyrevenue', 'type': 'numeric(10,2)'},
{'name': 'annual_increase_limit', 'type': 'number'},
{'name': 'site_id', 'type': 'number'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'salesrep_name', 'type': 'varchar'},
{'name': 'proposal_format_name', 'type': 'varchar'},
{'name': 'source', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> 4f71943348097e08bf897c819f49b561526606bd
