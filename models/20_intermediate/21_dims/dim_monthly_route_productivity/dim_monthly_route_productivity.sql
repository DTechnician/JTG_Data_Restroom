{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='monthly_route_productivity_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "monthly_route_productivity",
    natural_key = ["route_id", "period_id", "truckname","driver_name"],
    attributes = [
"division_id",
"lob_id",
"scheduled_count",
"scheduled_quantity",
"serviced_count",
"not_serviced_count",
"service_quantity",
"scheduled_volume",
"collected_volume",
"productivity_units",
"operating_hours",
"labor_hours",
"truck_distance",
"downtime_hours",
"non_recycle_quantity",
"disposal_count",
"disposalquantity",
"waste_quantity",
"recycle_quantity",
"disposal_cost",
"fuel",
"revenue",
"route_name",
"division_name",
"lob_name",
    ],
    scd_type = 2
) }}    