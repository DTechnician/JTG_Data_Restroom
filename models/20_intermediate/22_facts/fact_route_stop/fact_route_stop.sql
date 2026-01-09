{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='route_stop_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__route_stop',
    natural_key = ['id'],

    dimension_lookups = {
        'address': {
            'dim_model': 'dim_address',
            'dim_sk': 'address_sk',
            'src_keys': ['address_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [ 
        "address_id",
        "external_id",
        "name",
        "state",
        "notes",
        "live_sharing_url",
        "single_use_location_address",
        "single_use_location_latitude",
        "single_use_location_longitude",
        "route_id",
        "actual_arrival_time",
        "scheduled_departure_time",
        "actual_departure_time",
        "en_route_time",
        "scheduled_arrival_time",
        "skipped_time"
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/