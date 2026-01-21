{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='bill_batch_summary_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "bill_batch_summary",
    natural_key = ["billing_batch_id"],
    attributes = [
"billing_date",
"billing_from_date",
"billing_to_date",
"division_id",
"invoice_count",
"printable_count",
"eligible_for_email_count",
"autopay_enrolled_count",
"billing_batch_created_timestamp",
"billing_batch_completed_timestamp",
"billingbatch_amount",
"division_name",
"bill_group_id",
"bill_group_name",
"billing_batch_type",
"billing_batch_status",
"'Created by User'",
"'Completd by User'",
    ],
    scd_type = 2
) }}