{{ config(
    materialized='incremental',
    tag='facts',
    unique_key='fuel_energy_vehicle_id',
    incremental_strategy='merge'
) }}

{{ generate_fact_table(
    table_name = 'raw_samsara__fuel_energy_by_driver_report',
    natural_key = ['id'],

    dimension_lookups = {
        'driver': {
            'dim_model': 'dim_driver',
            'dim_sk': 'driver_sk',
            'src_keys': ['id'],
            'dim_keys': ['id']
        },

    },

    fact_fields = [ 
        "engine_runtime_duration_milli_seconds",
        "distance_traveled_meters",
        "est_carbon_emission_kg",
        "efficiency_mpge",
        "fuel_consumed_ml",
        "est_fuel_energy_cost_currency_code",
        "energy_used_kwh",
        "est_fuel_energy_cost_amount",
        "engine_idle_time_duration_milli_seconds",
    ],

    updated_at_column = '_fivetran_synced'
) }}

/*

----MS Meaning
Format: They are Unix millisecond UTC timestamps.
Purpose: These parameters define the beginning (startMs) and end (endMs) of the time window for which you want to retrieve data (e.g., a list of trips, sensor history, or driver assignments).
*/