{{ 
  generate_navusoft_staging(
    entity_name='v_query_monthly_route_productivity',
    unique_key='payload_hash',
    fields=[
{'name': 'route_id', 'type': 'number'},
{'name': 'division_id', 'type': 'number'},
{'name': 'scheduled_count', 'type': 'number'},
{'name': 'scheduled_quantity', 'type': 'number'},
{'name': 'serviced_count', 'type': 'number'},
{'name': 'not_serviced_count', 'type': 'number'},
{'name': 'non_recycle_quantity', 'type': 'number'},
{'name': 'disposal_count', 'type': 'number'},
{'name': 'waste_quantity', 'type': 'number'},
{'name': 'recycle_quantity', 'type': 'number'},
{'name': 'disposalquantity', 'type': 'number'},
{'name': 'disposal_cost', 'type': 'number'},
{'name': 'fuel', 'type': 'number'},
{'name': 'service_quantity', 'type': 'number'},
{'name': 'scheduled_volume', 'type': 'number'},
{'name': 'collected_volume', 'type': 'number'},
{'name': 'productivity_units', 'type': 'number'},
{'name': 'operating_hours', 'type': 'number'},
{'name': 'labor_hours', 'type': 'number'},
{'name': 'truck_distance', 'type': 'number'},
{'name': 'revenue', 'type': 'number'},
{'name': 'downtime_hours', 'type': 'number'},
{'name': 'route_name', 'type': 'varchar'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'lob_id', 'type': 'varchar'},
{'name': 'lob_name', 'type': 'varchar'},
{'name': 'driver_name', 'type': 'varchar'},
{'name': 'truckname', 'type': 'varchar'},
{'name': 'period_id', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> 4f71943348097e08bf897c819f49b561526606bd
