{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='alert_incident_conditions',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key=['configuration_id','updated_at_time']
) }}
