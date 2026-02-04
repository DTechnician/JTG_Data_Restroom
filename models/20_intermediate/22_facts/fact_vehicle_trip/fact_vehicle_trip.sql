{{ config(
    materialized='incremental',
    tag='facts',
<<<<<<< HEAD
    unique_key='trip_id',
=======
    unique_key='fact_sk',
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__vehicle_trip',
    natural_key = ['end_ms','start_ms','vehicle_id'],

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
        },
        'end_address': {
            'dim_model': 'dim_address',
            'dim_sk': 'address_sk',
            'src_keys': ['start_address_id'],
            'dim_keys': ['id']
        },
        'start_address': {
            'dim_model': 'dim_address',
            'dim_sk': 'address_sk',
            'src_keys': ['end_address_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [
        "driver_id",
        "start_address_id",
        "end_address_id",
        "start_coordinates_latitude",
        "end_coordinates_longitude",
        "start_odometer",
        "end_odometer",
        "start_coordinates_longitude",
        "end_coordinates_latitude",
        "start_location",
        "end_location",
        "toll_meters",
        "fuel_consumed_ml",
        "distance_meters",
    ],

    derived_fields = {
        'ms_duration': 'end_ms - start_ms',
        'odometer_delta': 'end_odometer - start_odometer'
    },

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/