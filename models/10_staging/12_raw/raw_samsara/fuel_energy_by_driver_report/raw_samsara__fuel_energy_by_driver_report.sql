{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='fuel_energy_by_driver_report',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= 'id'
) }}