{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='gps_location_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__gps',
    natural_key = ['time','vehicle_id'],

    dimension_lookups = {
        'vehicle': {
            'dim_model': 'dim_vehicle',
            'dim_sk': 'vehicle_sk',
            'src_keys': ['vehicle_id'],
            'dim_keys': ['id']
        },
        'address': {
            'dim_model': 'dim_address',
            'dim_sk': 'address_sk',
            'src_keys': ['address_id'],
            'dim_keys': ['id']
        }

    },

    fact_fields = [ 
        "address_id",
        "heading_degrees",
        "is_ecu_speed",
        "latitude",
        "longitude",
        "reverse_geo_formatted_location",
        "speed_miles_per_hour"
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/