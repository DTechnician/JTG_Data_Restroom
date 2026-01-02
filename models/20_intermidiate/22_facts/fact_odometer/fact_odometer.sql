{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='obd_odometer_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__obd_odometer',
    natural_key = ['time','vehicle_id'],

    dimension_lookups = {
        'vehicle': {
            'dim_model': 'dim_vehicle',
            'dim_sk': 'vehicle_sk',
            'src_keys': ['vehicle_id'],
            'dim_keys': ['id']
        },

    },

    fact_fields = [ 
        "value"
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/