select 

taxexempt,
divisionId,
accountId,
invoiceId,
totalsales,
taxablerevenue,
taxes,
siteId,
divisionname,
accountname,
sitename,
addressline1,
addressline2,
city,
state,
taxregionId,
period_id,
tax_name,
tax_authority_code,
tax_authority_type_name,
creditglaccount_id,
debitglaccount_id,
lob_id,
lob_name

from {{ ref('raw_navusoft__tax_details') }}