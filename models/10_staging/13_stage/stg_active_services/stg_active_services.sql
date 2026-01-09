select
    siteservice_id,
    site_id,
    vendor_site_id,
    division_id,
    serviceregion_id,
    equipmenttype_id,
    lob_id,
    materialtype_id,
    servicecode_id,
    default_destination_id,
    reasoncode_id,

    startdate,
    enddate,
    billed_through_date,

    service_frequency,
    routing_days,
    route_names,
    workorderminimum,
    inactivity_rental_free_days,
    inactivity_rental_rate,
    istemp,
    ownership,
    current_service_notes,

    quantity,
    equipment_size,
    uom,

    rate,
    vendor_rate,
    rate_per_yard,

    division_name,
    lob_name,
    serviceregionname,

    site_name,
    addressline1,
    city,
    state,
    postalcode,

    eqquipmenttype_name,
    materialname,

    servicecodename,
    default_destination,

    vendor_name

from {{ ref('raw_navusoft__active_services') }}
