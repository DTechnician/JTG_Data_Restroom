{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='safety_event_discontinued_20260917_000000',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key=['id']
) }}