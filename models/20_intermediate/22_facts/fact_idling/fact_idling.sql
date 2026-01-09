{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='idling_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__vehicle_idling_report',
    natural_key = ['_fivetran_id'],

    dimension_lookups = {
        'vehicle': {
            'dim_model': 'dim_vehicle',
            'dim_sk': 'vehicle_sk',
            'src_keys': ['vehicle_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [ 
        "vehicle_id",
        "is_pto_active",
        "address_latitude",
        "address_formatted",
        "address_longitude",
        "start_time",
        "end_time",
        "duration_ms",
        "fuel_consumption_ml",
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/