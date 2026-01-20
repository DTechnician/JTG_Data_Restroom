{{ config(materialized='view') }}

select 
    account_id,
    task_id,
    created_time_stamp,
    due_date,
    completed_time_stamp,
    site_id,
    account_name,
    site_name,
    task_type,
    task_note,
    priority,
    completionnote,
    created_by_user,
    assigned_to_user,
    payload_hash,
    rn,
from {{ref('raw_navusoft__task')}}
