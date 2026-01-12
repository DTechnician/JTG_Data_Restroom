select

-- Dates
expirationdate,
contract_effective_date,

-- Identifiers
id,
type_id,
proposalformtype_id,
division_id,
salesrep_id,
site_id,

-- Contract / Term info
term,
renewaltermmonths,
rate_guarantee_months,

-- Financial metrics
estimatedmonthlyrevenue,
annual_increase_limit,

-- Descriptive / Lookup
site_name,
division_name,
salesrep_name,
proposal_format_name,
source

from {{ ref('raw_navusoft__site_contract_statuscontract_status') }}