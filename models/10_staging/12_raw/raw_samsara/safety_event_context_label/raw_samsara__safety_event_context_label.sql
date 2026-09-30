{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='safety_event_context_label',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key=['safety_event_id','index']
) }}