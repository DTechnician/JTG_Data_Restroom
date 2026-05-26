{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='adp',
    table_name='worker_base_remuneration',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['worker_assignment_id', 'worker_id']
) }}