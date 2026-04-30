{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='route_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    sk_name = "route_sk",
    table_name = "daily_route_productivity",
    natural_key = ["route_id"],
    attributes = [
		'route_name',
        'division_id'
    ],
	foreign_keys = [
        {
            'name': 'site_division_sk',
            'dim_model': 'dim_site_division',
            'dim_sk': 'site_division_sk',
            'join_type': 'left',
            'join_on': [
                {'src': 'division_id', 'dim': 'site_division_id'}
            ]
        }
    ],
    dedupe_strategy = 'latest',
    scd_type = 2
) }}