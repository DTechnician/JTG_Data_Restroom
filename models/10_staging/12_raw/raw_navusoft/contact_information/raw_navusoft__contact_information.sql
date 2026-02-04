{{ 
  generate_navusoft_staging(
    entity_name='v_query_contactinformation',
    unique_key='payload_hash',
    fields=[
{'name': 'entitytype_id', 'type': 'number'},
{'name': 'status', 'type': 'varchar'},
{'name': 'contact_id', 'type': 'number'},
{'name': 'contactrole_id1', 'type': 'number'},
{'name': 'contactrole_id2', 'type': 'number'},
{'name': 'division_id', 'type': 'number'},
{'name': 'account_id', 'type': 'number'},
{'name': 'last_updated_time', 'type': 'timestamp_ntz'},
{'name': 'contact_entity_id', 'type': 'number'},
{'name': 'site_id', 'type': 'number'},
{'name': 'contact_uuid', 'type': 'varchar'},
{'name': 'contact_name', 'type': 'varchar'},
{'name': 'contact_title', 'type': 'varchar'},
{'name': 'contact_email', 'type': 'varchar'},
{'name': 'contact_phone', 'type': 'varchar'},
{'name': 'contact_note', 'type': 'varchar'},
{'name': 'contact_role1_name', 'type': 'varchar'},
{'name': 'contact_role2_name', 'type': 'varchar'},
{'name': 'receive_service_notifications', 'type': 'varchar'},
{'name': 'service_notification_method', 'type': 'varchar'},
{'name': 'ar_notification_method', 'type': 'varchar'},
{'name': 'contact_entity_type', 'type': 'varchar'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'name', 'type': 'varchar'},
{'name': 'name2', 'type': 'varchar'},
{'name': 'serviceregion_id', 'type': 'varchar'},
{'name': 'serviceregion_name', 'type': 'varchar'},
{'name': 'status_text', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
