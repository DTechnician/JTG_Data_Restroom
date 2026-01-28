SELECT

    details:geofenceEntry.vehicle.id::STRING AS vehicle_id,
    details:geofenceEntry.vehicle.name::STRING AS vehicle_name,
    details:geofenceEntry.vehicle.serial::STRING AS vehicle_serial,
    details:geofenceEntry.vehicle.externalIds."samsara.serial"::STRING AS samsara_serial,
    details:geofenceEntry.vehicle.externalIds."samsara.vin"::STRING AS samsara_vin,
    NULL AS truck_names,
    NULL AS truck_ids,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced,
    details:geofenceEntry.vehicle.gateway.model::STRING AS gateway_model,
    details:geofenceEntry.vehicle.gateway.serial::STRING AS gateway_serial

FROM {{ ref('raw_samsara__alert_incident_conditions') }}
WHERE details:geofenceEntry IS NOT NULL
