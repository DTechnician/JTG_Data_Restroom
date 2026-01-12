{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='cancellation_request_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "cancellation_request",
    natural_key = ["cancellation_status_id"],
    attributes = [
"cancellation_effectivedate",
"contract_start_date",
"target_resolution_date",
"Cancellation_CreatedDate",
"account_id",
"account_name",
"account_status",
"account_manager",
"site_id",
"site_name",
"site_serviceregion",
"site_salesrep",
"site_status",
"cancellation_status_text",
"reasoncode_name",
"cancellation_note",
"cancellation_contact",
"requested_by",
"createdby_user",
"average_monthly_revenue",
    ],
    scd_type = 2
) }}