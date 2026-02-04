{{ 
  generate_navusoft_staging(
    entity_name='v_query_manifestconsolidationbatch',
    unique_key='payload_hash',
    fields=[
{'name': 'shipdate', 'type': 'timestamp_ntz'},
{'name': 'status', 'type': 'varchar'},
{'name': 'id', 'type': 'number'},
{'name': 'external_id', 'type': 'number'},
{'name': 'servicerecord_id', 'type': 'number'},
{'name': 'workordernumber', 'type': 'number'},
{'name': 'source_name', 'type': 'varchar'},
{'name': 'transporter_name', 'type': 'varchar'},
{'name': 'destination_name', 'type': 'varchar'},
{'name': 'note', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
