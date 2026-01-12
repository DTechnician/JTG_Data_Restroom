select 

-- Identifiers
task_id,
account_id,
site_id,

-- Timestamps / lifecycle dates
created_time_stamp,
due_date,
completed_time_stamp,

-- Account / site context
account_name,
site_name,

-- Task attributes
task_type,
priority,

-- Notes / descriptions
task_note,
completionnote,

-- User / assignment metadata
created_by_user,
assigned_to_user

from {{ ref('raw_navusoft__task') }}