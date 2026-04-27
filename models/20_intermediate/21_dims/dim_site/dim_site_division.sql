{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='site_division_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "site_division_sk",
    table_name = "account_and_site",
    natural_key = ["site_division_id"],
    attributes = [
        'site_division_name'
    ],
	derived_attributes = [
		{'name': 'division_hourly_rate',
			'expr': "case 
                when site_division_id in (1001,1004) then 21
                when site_division_id in (1002) then 24
                when site_division_id in (1003) then 27
                end" 
		},
		{'name': 'division_ot_rate',
			'expr': "case 
                when site_division_id in (1001,1004) then 31.5
                when site_division_id in (1002) then 36
                when site_division_id in (1003) then 40.5
                end" 
		}
	],
    dedupe_strategy = 'latest',
    scd_type = 2
) }}