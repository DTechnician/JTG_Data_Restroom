SELECT
    vehicle_id,
    vehicle_name,
    vehicle_serial,
    samsara_serial,
    samsara_vin,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    NULL::STRING AS gateway_model,
    NULL::STRING AS gateway_serial,
    NULL::NUMBER AS current_speed_kph,
    NULL::NUMBER AS threshold_speed_kph,
    NULL::STRING AS speed_operation,
    NULL::NUMBER AS min_duration_ms
FROM {{ ref('stg_vehicle_def_level') }}

UNION ALL

SELECT
    vehicle_id,
    vehicle_name,
    vehicle_serial,
    samsara_serial,
    samsara_vin,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    NULL::STRING AS gateway_model,
    NULL::STRING AS gateway_serial,
    NULL::NUMBER AS current_speed_kph,
    NULL::NUMBER AS threshold_speed_kph,
    NULL::STRING AS speed_operation,
    NULL::NUMBER AS min_duration_ms
FROM {{ ref('stg_gateway_unplugged') }}

UNION ALL

SELECT
    vehicle_id,
    vehicle_name,
    vehicle_serial,
    samsara_serial,
    samsara_vin,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    NULL::STRING AS gateway_model,
    NULL::STRING AS gateway_serial,
    current_speed_kph,
    threshold_speed_kph,
    speed_operation,
    min_duration_ms
FROM {{ ref('stg_speed') }}

UNION ALL

SELECT
    vehicle_id,
    vehicle_name,
    vehicle_serial,
    samsara_serial,
    samsara_vin,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    NULL::STRING AS gateway_model,
    NULL::STRING AS gateway_serial,
    NULL::NUMBER AS current_speed_kph,
    NULL::NUMBER AS threshold_speed_kph,
    NULL::STRING AS speed_operation,
    NULL::NUMBER AS min_duration_ms
FROM {{ ref('stg_harsh_event') }}

UNION ALL

SELECT
    vehicle_id,
    vehicle_name,
    vehicle_serial,
    samsara_serial,
    samsara_vin,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    NULL::STRING AS gateway_model,
    NULL::STRING AS gateway_serial,
    NULL::NUMBER AS current_speed_kph,
    NULL::NUMBER AS threshold_speed_kph,
    NULL::STRING AS speed_operation,
    NULL::NUMBER AS min_duration_ms
FROM {{ ref('stg_engine_idle') }}

UNION ALL

SELECT
    vehicle_id,
    vehicle_name,
    vehicle_serial,
    samsara_serial,
    samsara_vin,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    NULL::STRING AS gateway_model,
    NULL::STRING AS gateway_serial,
    NULL::NUMBER AS current_speed_kph,
    NULL::NUMBER AS threshold_speed_kph,
    NULL::STRING AS speed_operation,
    NULL::NUMBER AS min_duration_ms
FROM {{ ref('stg_scheduled_maintenance') }}

UNION ALL

SELECT
    vehicle_id,
    vehicle_name,
    vehicle_serial,
    samsara_serial,
    samsara_vin,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    gateway_model,
    gateway_serial,
    NULL::NUMBER AS current_speed_kph,
    NULL::NUMBER AS threshold_speed_kph,
    NULL::STRING AS speed_operation,
    NULL::NUMBER AS min_duration_ms
FROM {{ ref('stg_geofence_entry') }}