{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='gps_distance_meter',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key=  ['time','vehicle_id']
) }}