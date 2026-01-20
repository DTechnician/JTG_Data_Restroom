select
    route_id, 
    route_name,

    division_id,
    division_name,

    weeknum,
    period_id,

    scheduleddate,
    scheduledquantity,
    scheduledcount,
    scheduledvolume,

    servicedcount,
    servicequantity,

    notservicedcount,

    disposalcount,
    disposalquantity,
    disposalcost,

    collectedvolume,
    waste_quantity,
    non_recycle_quantity,
    recycle_quantity,

    fuel,
    

    productivityunits,
    operating_hours,
    labor_hours,
    truckmiles,
    revenue,

    downtime_hours,
    
    lob_id,
    lob_name,
    truck_state,
    driver_name,
    truckname,
    error_message,
    disposaluom,
    payload_hash,
    rn,
from {{ref('raw_navusoft__daily_route_productivity')}}