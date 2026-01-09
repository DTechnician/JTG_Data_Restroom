{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='safety_event_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__safety_event',
    natural_key = ['id'],

    dimension_lookups = {
        'vehicle': {
            'dim_model': 'dim_vehicle',
            'dim_sk': 'vehicle_sk',
            'src_keys': ['vehicle_id'],
            'dim_keys': ['id']
        },
        'driver': {
            'dim_model': 'dim_driver',
            'dim_sk': 'driver_sk',
            'src_keys': ['driver_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [ 
        'vehicle_id',
        'driver_id',
        'coaching_state',
        'max_acceleration_gforce',
        'location_latitude',
        'location_longitude',
        'time'
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/