{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='work_type_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "work_type_sk",
    table_name = "work_order",
    natural_key = ["work_type_id"],
    attributes = [ 
		"work_type_name"
    ],    
    derived_attributes = [
        { 'name': 'work_type',
		'expr': "case   
					when lower(work_type_id) like '%service%' then 'Service'
					when lower(work_type_id) like '%deliver%' then 'Pick & Drop'
					when lower(work_type_id) like '%remove%' then 'Pick & Drop'
					else 'Others'
				end" 
		}
    ],
    dedupe_strategy = 'latest',
    scd_type = 2
) }}