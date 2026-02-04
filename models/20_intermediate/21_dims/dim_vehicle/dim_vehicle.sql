{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='vehicle_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "vehicle",
    natural_key = ["id"],
    attributes = [
        "aux_input_12",
        "model",
        "aux_input_1",
        "aux_input_6",
        "aux_input_9",
        "license_plate",
        "vehicle_regulation_mode",
        "external_id",
        "harsh_acceleration_setting",
        "aux_input_11",
        "name",
        "aux_input_7",
        "make",
        "year",
        "aux_input_13",
        "aux_input_10",
        "aux_input_4",
        "aux_input_2",
        "notes",
        "aux_input_3",
        "vin",
        "aux_input_5",
        "engine_serial_number",
        "gateway_serial",
        "aux_input_8"
    ],
    scd_type = 2
<<<<<<< HEAD
) }}
=======
) }}
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
