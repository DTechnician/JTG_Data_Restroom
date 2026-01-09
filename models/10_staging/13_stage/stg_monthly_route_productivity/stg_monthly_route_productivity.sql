select 

-- Identifiers
route_id,
division_id,
period_id,
lob_id,
truckname,
driver_name,

-- Scheduled / Operational metrics
scheduled_count,
scheduled_quantity,
serviced_count,
not_serviced_count,
service_quantity,
scheduled_volume,
collected_volume,
productivity_units,
operating_hours,
labor_hours,
truck_distance,
downtime_hours,
non_recycle_quantity,
disposal_count,
disposalquantity,
waste_quantity,
recycle_quantity,
disposal_cost,
fuel,
revenue,

-- Descriptive attributes
route_name,
division_name,
lob_name

from {{ ref('raw_navusoft__monthly_route_productivity') }}