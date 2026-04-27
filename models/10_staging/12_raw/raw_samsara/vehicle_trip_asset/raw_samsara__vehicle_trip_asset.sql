{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='vehicle_trip_asset',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key='trailer_id'
) }}