{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='samsara',
    table_name='user_role',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['users_id','index']
) }}
