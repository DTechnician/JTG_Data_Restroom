{{ config(
    materialized='incremental',
    unique_key='alert_incident_conditions',
    incremental_strategy='merge',
    merge_update_columns=[
        'vehicle_name',
        'vehicle_serial',
        'samsara_serial',
        'samsara_vin',
        'description',
        'configuration_id',
        'updated_at_time',
        'gateway_model',
        'gateway_serial',
        'current_speed_kph',
        'threshold_speed_kph',
        'speed_operation',
        'min_duration_ms',
        'event_type',
        'truck_ids',
        'truck_names'
    ]
) }}

WITH source_data AS (

    SELECT 
        *,
        -- create a unique key per event (vehicle + trigger + description + updated_at_time)
        MD5(CONCAT(
            COALESCE(vehicle_id, ''), '|',
            COALESCE(trigger_id, ''), '|',
            COALESCE(description, ''), '|',
            COALESCE(TO_VARCHAR(updated_at_time), '')
        )) AS vehicle_event_sk,
        -- determine event type by checking which column group is populated
        CASE 
            WHEN gateway_model IS NOT NULL OR gateway_serial IS NOT NULL THEN 'geofence_entry'
            WHEN current_speed_kph IS NOT NULL THEN 'speed'
            WHEN _fivetran_deleted IS NOT NULL AND description IS NOT NULL THEN 'vehicle_def_level'
            ELSE 'other'
        END AS event_type
    FROM {{ ref('stg_union_events') }}
),

tags_agg AS (
    SELECT
        vehicle_id,
        LISTAGG(truck_id, ',') AS truck_ids,
        LISTAGG(truck_name, ',') AS truck_names
    FROM {{ ref('stg_vehicle_tags') }}
    GROUP BY vehicle_id
)

SELECT
    s.vehicle_event_sk,
    s.vehicle_id,
    s.vehicle_name,
    s.vehicle_serial,
    s.samsara_serial,
    s.samsara_vin,
    s.description,
    s.trigger_id,
    s.configuration_id,
    s.updated_at_time,
    s._fivetran_deleted,
    s._fivetran_synced,
    s.gateway_model,
    s.gateway_serial,
    s.current_speed_kph,
    s.threshold_speed_kph,
    s.speed_operation,
    s.min_duration_ms,
    s.event_type,
    t.truck_ids,
    t.truck_names

FROM source_data s
LEFT JOIN tags_agg t
ON s.vehicle_id = t.vehicle_id
