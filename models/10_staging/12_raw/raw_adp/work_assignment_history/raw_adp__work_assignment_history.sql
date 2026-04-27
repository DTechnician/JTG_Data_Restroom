{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='adp',
    table_name='work_assignment_history',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['worker_id', 'id', '_fivetran_start']
) }}