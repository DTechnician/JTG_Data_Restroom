{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='tag_address',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['address_id','index']
) }}
