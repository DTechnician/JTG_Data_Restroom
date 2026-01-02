{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='vehicle_trip_asset_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__vehicle_trip_asset',
    natural_key = ['trailer_id'],

    dimension_lookups = {
        'vehicle': {
            'dim_model': 'dim_vehicle',
            'dim_sk': 'vehicle_sk',
            'src_keys': ['vehicle_trip_vehicle_id'],
            'dim_keys': ['id']
        },
        'trailer': {
            'dim_model': 'dim_trailer',
            'dim_sk': 'trailer_sk',
            'src_keys': ['trailer_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [ 
        "vehicle_trip_vehicle_id",
        "vehicle_trip_end_ms",
        "vehicle_trip_start_ms",
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/