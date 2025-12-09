{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='hos_log',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key=  ['log_end_time','log_start_time','vehicle_id']
) }}
