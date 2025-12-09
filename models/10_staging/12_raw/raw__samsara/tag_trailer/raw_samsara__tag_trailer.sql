{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='tag_trailer',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['trailer_id','index']
) }}
