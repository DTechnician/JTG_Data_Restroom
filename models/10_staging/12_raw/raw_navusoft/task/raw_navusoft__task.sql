{{ 
  generate_navusoft_staging(
    entity_name='v_query_task',
    unique_key='payload_hash',
    fields=[
{'name': 'account_id', 'type': 'number'},
{'name': 'task_id', 'type': 'number'},
{'name': 'created_time_stamp', 'type': 'timestamp_ntz'},
{'name': 'due_date', 'type': 'timestamp_ntz'},
{'name': 'completed_time_stamp', 'type': 'timestamp_ntz'},
{'name': 'site_id', 'type': 'number'},
{'name': 'account_name', 'type': 'varchar'},
{'name': 'site_name', 'type': 'varchar'},
{'name': 'task_type', 'type': 'varchar'},
{'name': 'task_note', 'type': 'varchar'},
{'name': 'priority', 'type': 'varchar'},
{'name': 'completionnote', 'type': 'varchar'},
{'name': 'created_by_user', 'type': 'varchar'},
{'name': 'assigned_to_user', 'type': 'varchar'},

    ]
  )
}}