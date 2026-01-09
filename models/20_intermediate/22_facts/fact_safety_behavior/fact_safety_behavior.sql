{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='trip_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__safety_behavior',
    natural_key = ["label","safety_event_id"],

    dimension_lookups = {
        'safety_behavior': {
            'dim_model': 'dim_safety_behavior',
            'dim_sk': 'safety_behavior_sk',
            'src_keys':["label","safety_event_id"],
            'dim_keys': ["label","safety_event_id"]
        },

    },

    fact_fields = [
        "name",
        "source",
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/