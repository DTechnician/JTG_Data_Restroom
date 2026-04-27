{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='equipment_type_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "equipment_type_sk",
    table_name = "site_service_history",
    natural_key = ["EQUIPMENTTYPE_ID"],
    attributes = [
    ],
    derived_attributes = [
        { 'name': 'equipment_type_name',
			'expr': "equipmenttype_name" 
		},
		{ 'name': 'EQUIPMENT_TYPE_ID',
			'expr': "EQUIPMENTTYPE_ID" 
		}
    ],
    dedupe_strategy = 'latest',
    scd_type = 2
) }}