WITH all_tags AS (
    -- vehicleDefLevelPercentage tags
    SELECT 
        details:vehicleDefLevelPercentage.vehicle.id::STRING AS vehicle_id,
        tag.value:id::STRING AS truck_id,
        tag.value:name::STRING AS truck_name
    FROM {{ ref('raw_samsara__alert_incident_conditions') }}
    LEFT JOIN LATERAL FLATTEN(input => details:vehicleDefLevelPercentage.vehicle.tags) tag
    WHERE details:vehicleDefLevelPercentage IS NOT NULL

    UNION ALL

    -- harshEvent vehicle tags
    SELECT 
        details:harshEvent.vehicle.id::STRING AS vehicle_id,
        tag.value:id::STRING AS truck_id,
        tag.value:name::STRING AS truck_name
    FROM {{ ref('raw_samsara__alert_incident_conditions') }}
    LEFT JOIN LATERAL FLATTEN(input => details:harshEvent.vehicle.tags) tag
    WHERE details:harshEvent IS NOT NULL

    UNION ALL

    -- speed vehicle tags
    SELECT 
        details:speed.vehicle.id::STRING AS vehicle_id,
        tag.value:id::STRING AS truck_id,
        tag.value:name::STRING AS truck_name
    FROM {{ ref('raw_samsara__alert_incident_conditions') }}
    LEFT JOIN LATERAL FLATTEN(input => details:speed.vehicle.tags) tag
    WHERE details:speed IS NOT NULL

    UNION ALL

    -- engineIdle vehicle tags
    SELECT 
        details:engineIdle.vehicle.id::STRING AS vehicle_id,
        tag.value:id::STRING AS truck_id,
        tag.value:name::STRING AS truck_name
    FROM {{ ref('raw_samsara__alert_incident_conditions') }}
    LEFT JOIN LATERAL FLATTEN(input => details:engineIdle.vehicle.tags) tag
    WHERE details:engineIdle IS NOT NULL

    UNION ALL

    -- scheduledMaintenanceOdometer vehicle tags
    SELECT 
        details:scheduledMaintenanceOdometer.vehicle.id::STRING AS vehicle_id,
        tag.value:id::STRING AS truck_id,
        tag.value:name::STRING AS truck_name
    FROM {{ ref('raw_samsara__alert_incident_conditions') }}
    LEFT JOIN LATERAL FLATTEN(input => details:scheduledMaintenanceOdometer.vehicle.tags) tag
    WHERE details:scheduledMaintenanceOdometer IS NOT NULL
)

SELECT DISTINCT *
FROM all_tags