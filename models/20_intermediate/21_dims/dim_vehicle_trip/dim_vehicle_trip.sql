{{ config(
    materialized='incremental',
    tags=['dims'],
    unique_key='vehicle_trip_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "vehicle_trip",
    natural_key = ["end_ms","start_ms","vehicle_id"],
    attributes = [
    "end_coordinates_longitude",
    "fuel_consumed_ml",
    "start_coordinates_latitude",
    "distance_meters",
    "end_odometer",
    "end_coordinates_latitude",
    "end_address_id",
    "end_location",
    "start_address_id",
    "start_coordinates_longitude",
    "driver_id",
    "start_location",
    "start_odometer",
    "toll_meters"
    ],
    scd_type = 2
) }}