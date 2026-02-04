{{ 
  generate_navusoft_staging(
    entity_name='v_query_daily_route_productivity',
    unique_key='payload_hash',
    fields=[
{'name': 'scheduleddate', 'type': 'timestamp_ntz'},
{'name': 'route_id', 'type': 'number'},
{'name': 'division_id', 'type': 'number'},
{'name': 'weeknum', 'type': 'number'},
{'name': 'scheduledQuantity', 'type': 'number'},
{'name': 'scheduledCount', 'type': 'number'},
{'name': 'servicedCount', 'type': 'number'},
{'name': 'notservicedCount', 'type': 'number'},
{'name': 'non_recycle_quantity', 'type': 'number'},
{'name': 'disposalcount', 'type': 'number'},
{'name': 'waste_quantity', 'type': 'number'},
{'name': 'recycle_quantity', 'type': 'number'},
{'name': 'disposalquantity', 'type': 'number'},
{'name': 'disposalcost', 'type': 'number'},
{'name': 'fuel', 'type': 'number'},
{'name': 'serviceQuantity', 'type': 'number'},
{'name': 'scheduledVolume', 'type': 'number'},
{'name': 'collectedvolume', 'type': 'number'},
{'name': 'productivityunits', 'type': 'number'},
{'name': 'operating_hours', 'type': 'number'},
{'name': 'labor_hours', 'type': 'number'},
{'name': 'truckMiles', 'type': 'number'},
{'name': 'revenue', 'type': 'number'},
{'name': 'downtime_hours', 'type': 'number'},
{'name': 'route_name', 'type': 'varchar'},
{'name': 'division_name', 'type': 'varchar'},
{'name': 'lob_id', 'type': 'varchar'},
{'name': 'lob_name', 'type': 'varchar'},
{'name': 'period_id', 'type': 'varchar'},
{'name': 'truck_state', 'type': 'varchar'},
{'name': 'driver_name', 'type': 'varchar'},
{'name': 'truckname', 'type': 'varchar'},
{'name': 'error_message', 'type': 'varchar'},
{'name': 'disposaluom', 'type': 'varchar'},

    ]
  )
<<<<<<< HEAD
}}
=======
}}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
