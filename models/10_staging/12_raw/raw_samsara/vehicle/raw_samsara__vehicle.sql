{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='vehicle',
    column_expressions=columns,
    incremental_filter_column='updated_at_time',
    unique_key='id'
) }}