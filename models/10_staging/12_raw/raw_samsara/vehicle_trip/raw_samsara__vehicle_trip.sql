{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='vehicle_trip',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['end_ms','start_ms','vehicle_id']
) }}