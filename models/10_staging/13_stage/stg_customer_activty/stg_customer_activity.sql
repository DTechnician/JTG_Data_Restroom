select 

-- Identifiers
account_id,
record_id,
site_id,

-- Account attributes
account_name,
account_division,
account_divisionname,
accountclass_name,
account_addressline1,
account_addressline2,
account_city,
account_state,
account_zip_code,
account_billing_phone,
account_phone1,
account_email,

-- Site attributes
site_name,
site_divisionname,
site_addressline1,
site_addressline2,
site_city,
site_state,
site_zipcode,
siteclass_name,

-- Billing / classification
billinggroup_name,
service_region,
taxregion_name,

-- Task / activity attributes
type,
title,
notes,
assigned_to,
created_by,
status,
completion_note,

-- Dates / timestamps
due_date,
completed_date,
appointment_datetime,
creation_datetime

from {{ ref('raw_navusoft__customer_activity') }}