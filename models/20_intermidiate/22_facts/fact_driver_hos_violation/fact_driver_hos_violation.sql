{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='driver_hos_violation_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__driver_hos_violation',
    natural_key = ['driver_id','day_start_time','type'],

    dimension_lookups = {

        'driver': {
            'dim_model': 'dim_driver',
            'dim_sk': 'driver_sk',
            'src_keys': ['driver_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [ 
        "description",
        "duration_ms",
        "day_end_time",
        "violation_start_time"
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/