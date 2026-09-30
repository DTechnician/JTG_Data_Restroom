{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='engine_coolant_temperature_milli_c',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key=['vehicle_id','time']
) }}