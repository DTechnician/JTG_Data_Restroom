select
site_id,

--site geographical hierarchy
site_address_line_1,
site_address_line_2,
site_city,
site_state_id,
site_state,
site_zip,
site_county,
site_division_id,
site_division_name,
site_serviceregion_id,
site_service_region_name,

--site details
site_name,
site_name_2,
site_phone_1,
site_phone_2,
site_ponumber,
site_accessinformation,
site_businesshours,
site_old_id,

site_taxexempt_id,
site_taxexemptreason,


site_broker_id,
site_broker_name,

site_surchargegroup_id,
site_surchargegroup_name,


site_class_id,
site_class_name,

site_bill_to_selection,
site_billgroup_id,
site_billgroup_name,


site_tax_region_id,
site_taxregion_name,

site_warningnote,
site_epa_id,

--site history

site_generator_type_id,
site_generator_type_name,

site_source_id,
site_source_name,

site_salesrep_id,
site_salesrep_name,

site_created_by_user,
site_created_timestamp,
site_status_effective_date,
site_status,
site_status_text,
from {{ref('raw_navusoft__account_and_site')}}