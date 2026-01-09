select 

-- Identifiers
workordernumber,
site_id,
division_id,
account_id,
route_id,
route_default_disposallocation_id,
truck_id,
driver_id,
posted_user_id,
contact_id,
lob_id,

-- Dates
scheduled_date,
posted_date,
completion_date,
createdtimestamp,

-- Operational / activity metrics
quantity,
disposal_quantity,
sequence,
minutes,
optimizationtraveltime,
optimizationdistance,
equipment_volume,
work_order_weight,
wominimumchargeamount,

-- Financial metrics
workorder_revenue,
revenue,
surcharge_revenue,
total_revenue,
service_cost,
disposal_cost,
disposal_costs,
total_cost,
profit,

-- Status / workflow
status,
posting_status

from {{ ref('raw_navusoft__work_order') }}