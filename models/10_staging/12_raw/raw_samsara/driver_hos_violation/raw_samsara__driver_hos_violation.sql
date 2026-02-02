{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='driver_hos_violation',
    column_expressions=columns,
    incremental_filter_column='_FIVETRAN_SYNCED',
    unique_key=['driver_id','day_start_time','type']
) }}