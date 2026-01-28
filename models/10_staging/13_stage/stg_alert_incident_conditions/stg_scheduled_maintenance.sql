SELECT

    details:scheduledMaintenanceOdometer.vehicle.id::STRING AS vehicle_id,
    details:scheduledMaintenanceOdometer.vehicle.name::STRING AS vehicle_name,
    details:scheduledMaintenanceOdometer.vehicle.serial::STRING AS vehicle_serial,
    details:scheduledMaintenanceOdometer.vehicle.externalIds."samsara.serial"::STRING AS samsara_serial,
    details:scheduledMaintenanceOdometer.vehicle.externalIds."samsara.vin"::STRING AS samsara_vin,
    ARRAY_AGG(tag.value:name::STRING) AS truck_names,
    ARRAY_AGG(tag.value:id::STRING) AS truck_ids,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced

FROM {{ ref('raw_samsara__alert_incident_conditions') }}
LEFT JOIN LATERAL FLATTEN(input => details:scheduledMaintenanceOdometer.vehicle.tags) tag
WHERE details:scheduledMaintenanceOdometer IS NOT NULL
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
    _fivetran_synced
