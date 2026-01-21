select

lastcollectionsactivity,
lastpayment,
account_status,
division_id,
account_id,
average_days_to_pay,
unappliedamount,
current_amount,
oneto30amount,
thirtyoneto60amount,
sixtyoneto90amount,
ninetyoneto120amount,
over120amount,
total,
division_name,
account_name,
account_status_text,
auditor_name,
billgroup_id,
billgroup_name

from {{ ref('raw_navusoft__current_aging') }}