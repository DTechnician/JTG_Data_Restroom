SELECT

    details:speed.vehicle.id::STRING AS vehicle_id,
    details:speed.vehicle.name::STRING AS vehicle_name,
    details:speed.vehicle.serial::STRING AS vehicle_serial,
    details:speed.vehicle.externalIds."samsara.serial"::STRING AS samsara_serial,
    details:speed.vehicle.externalIds."samsara.vin"::STRING AS samsara_vin,
    ARRAY_AGG(tag.value:name::STRING) AS truck_names,
    ARRAY_AGG(tag.value:id::STRING) AS truck_ids,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    details:speed.currentSpeedKilometersPerHour::NUMBER AS current_speed_kph,
    details:speed.thresholdSpeedKilometersPerHour::NUMBER AS threshold_speed_kph,
    details:speed.operation::STRING AS speed_operation,
    details:speed.minDurationMilliseconds::NUMBER AS min_duration_ms
    
FROM {{ ref('raw_samsara__alert_incident_conditions') }}
LEFT JOIN LATERAL FLATTEN(input => details:speed.vehicle.tags) tag
WHERE details:speed IS NOT NULL
GROUP BY
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
    current_speed_kph,
    threshold_speed_kph,
    speed_operation,
    min_duration_ms