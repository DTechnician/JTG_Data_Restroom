SELECT

    details:gatewayUnplugged.vehicle.id::STRING AS vehicle_id,
    details:gatewayUnplugged.vehicle.name::STRING AS vehicle_name,
    details:gatewayUnplugged.vehicle.serial::STRING AS vehicle_serial,
    details:gatewayUnplugged.vehicle.externalIds."samsara.serial"::STRING AS samsara_serial,
    details:gatewayUnplugged.vehicle.externalIds."samsara.vin"::STRING AS samsara_vin,
    NULL AS truck_names,
    NULL AS truck_ids,
    description,
    trigger_id,
    configuration_id,
    updated_at_time,
    _fivetran_deleted,
    _fivetran_synced

FROM {{ ref('raw_samsara__alert_incident_conditions') }}
WHERE details:gatewayUnplugged IS NOT NULL
