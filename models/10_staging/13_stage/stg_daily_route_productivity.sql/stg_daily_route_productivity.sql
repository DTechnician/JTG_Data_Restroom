select

-- Identifiers
route_id,
division_id,
period_id,
lob_id,
truckname,
driver_name,
truck_state,

-- Dates / Time
weeknum,
scheduleddate,

-- Descriptive attributes
route_name,
division_name,
lob_name,
disposaluom,
error_message,

-- Scheduled / Operational metrics
scheduledQuantity,
scheduledCount,
servicedCount,
notservicedCount,
serviceQuantity,
scheduledVolume,
collectedvolume,
productivityunits,
operating_hours,
labor_hours,
truckMiles,
downtime_hours,

-- Disposal / Waste metrics
disposalquantity,
non_recycle_quantity,
recycle_quantity,
waste_quantity,
disposalcount,

-- Financial / cost metrics
disposalcost,
fuel,
revenue



from {{ ref('raw_navusoft__daily_route_productivity') }}