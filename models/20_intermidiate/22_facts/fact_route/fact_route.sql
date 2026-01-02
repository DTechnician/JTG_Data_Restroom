{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='route_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__route',
    natural_key = ['id'],

    dimension_lookups = {
        'driver': {
            'dim_model': 'dim_driver',
            'dim_sk': 'driver_sk',
            'src_keys': ['driver_id'],
            'dim_keys': ['id']
        },
        'vehicle': {
            'dim_model': 'dim_vehicle',
            'dim_sk': 'vehicle_sk',
            'src_keys': ['vehicle_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [ 
        "driver_id",
        "vehicle_id",
        "external_id",
        "name",
        "notes",
        "starting_condition",
        "completion_condition",
        "scheduled_route_start_time",
        "scheduled_route_end_time",
        "actual_route_start_time",
        "actual_route_end_time",
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/