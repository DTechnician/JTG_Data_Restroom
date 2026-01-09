{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='obdii_diagnostic_trouble_code_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__obdii_diagnostic_trouble_code',
    natural_key = ['tx_id'],

    dimension_lookups = {
        'vehicle': {
            'dim_model': 'dim_vehicle',
            'dim_sk': 'vehicle_sk',
            'src_keys': ['fault_code_vehicle_id'],
            'dim_keys': ['id']
        }
    },

    fact_fields = [ 
        "ignition_type",
        "mil_status",
        "monitor_status_evap_system",
        "monitor_status_egr",
        "monitor_status_comprehensive",
        "monitor_status_o_2_sensor",
        "monitor_status_fuel",
        "monitor_status_iso_sae_reserved",
        "monitor_status_not_ready_count",
        "monitor_status_misfire",
        "monitor_status_secondary_air",
        "monitor_status_heated_catalyst",
        "monitor_status_heated_o_2_sensor",
        "monitor_status_catalyst",
        "fault_code_vehicle_id",
        "_fivetran_deleted",
        "fault_code_time",
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/