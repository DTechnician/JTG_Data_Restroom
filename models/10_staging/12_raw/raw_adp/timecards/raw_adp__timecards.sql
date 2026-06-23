{% set columns = [
    "*"
] %}

{{ generate_staging_model(
    source_name='adp_custom',
    table_name='timecards',
    column_expressions=columns,
    incremental_filter_column='_fivetran_synced',
    unique_key= ['associate_id','timecard_id','date']
) }}