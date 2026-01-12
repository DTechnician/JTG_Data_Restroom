select 

-- Dates
cancellation_effectivedate,
contract_start_date,
target_resolution_date,
cancellation_createddate,

-- Account identifiers
account_id,
account_name,
account_status,
account_manager,

-- Site identifiers
site_id,
site_name,
site_serviceregion,
site_salesrep,
site_status,

-- Cancellation info
cancellation_status_id,
cancellation_status_text,
reasoncode_name,
cancellation_note,
cancellation_contact,
requested_by,
createdby_user,

-- Financial metrics
average_monthly_revenue

from {{ ref('raw_navusoft__cancellation_request') }}