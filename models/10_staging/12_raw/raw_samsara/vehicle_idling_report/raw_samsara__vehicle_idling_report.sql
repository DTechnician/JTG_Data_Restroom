{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='vehicle_idling_report',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key='_fivetran_id'
) }}