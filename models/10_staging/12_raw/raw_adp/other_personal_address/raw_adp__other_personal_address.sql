{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='adp',
    table_name='other_personal_address',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= 'id'
) }}