{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='current_aging_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "current_aging",
    natural_key = ["account_id"],
    attributes = [
"lastcollectionsactivity",
"lastpayment",
"account_status",
"division_id",
"average_days_to_pay",
"unappliedamount",
"current_amount",
"oneto30amount",
"thirtyoneto60amount",
"sixtyoneto90amount",
"ninetyoneto120amount",
"over120amount",
"total",
"division_name",
"account_name",
"account_status_text",
"auditor_name",
"billgroup_id",
"billgroup_name",
    ],
    scd_type = 2
) }}