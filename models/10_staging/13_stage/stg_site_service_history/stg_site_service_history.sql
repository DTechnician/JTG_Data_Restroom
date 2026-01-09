select
start_date,
end_date,
billed_thru_date,
start_posted_timestamp,
end_posted_timestamp,

site_division_id,
site_id,
service_id,
service_code_id,
lob_id,
equipmenttype_id,
lost_to_competitor_id,

quantity,
perunitrate,
rate,

site_name,
site_address_line_1,
site_address_line_2,
site_city,
site_state,
site_zip,

service_code_name,
lob_name,
equipmenttype_name,
service_frequency,
lost_to_competitor_name,

start_reason_code,
start_user_name,
end_reason_code,
end_user_name

from {{ ref('raw_navusoft__site_service_history') }}