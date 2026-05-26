{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='adp',
    table_name='person_social_insurance_program',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['worker_id', 'id']
) }}