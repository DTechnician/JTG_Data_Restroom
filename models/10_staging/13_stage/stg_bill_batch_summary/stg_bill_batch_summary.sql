select 

billing_date,
billing_from_date,
billing_to_date,
billing_batch_id,
division_id,
invoice_count,
printable_count,
eligible_for_email_count,
autopay_enrolled_count,
billing_batch_created_timestamp,
billing_batch_completed_timestamp,
billingbatch_amount,
division_name,
bill_group_id,
bill_group_name,
billing_batch_type,
billing_batch_status,
"Created by User" as created_by_user,
"Completd by User" as completed_by_user

from {{ ref('raw_navusoft__bill_batch_summary') }}