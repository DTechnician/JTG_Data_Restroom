{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='vehicle_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "vehicle_sk",
    table_name = "work_order",
    natural_key = ["truck_id"],
    attributes = [
    ],
    derived_attributes = [
        { 'name': 'vehicle_name',
			'expr': "truck_name" 
		},
		{ 'name': 'vehicle_id',
			'expr': "truck_id" 
		}
    ],
    dedupe_strategy = 'latest',
    scd_type = 2
) }}