{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='task_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "task",
    natural_key = ["task_id"],
    attributes = [
"account_id",
"site_id",
"created_time_stamp",
"due_date",
"completed_time_stamp",
"account_name",
"site_name",
"task_type",
"priority",
"task_note",
"completionnote",
"created_by_user",
"assigned_to_user",
    ],
    scd_type = 2
) }}