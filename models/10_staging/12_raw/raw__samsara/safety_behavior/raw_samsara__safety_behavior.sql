{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='safety_behavior',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['label','safety_event_id']
) }}
