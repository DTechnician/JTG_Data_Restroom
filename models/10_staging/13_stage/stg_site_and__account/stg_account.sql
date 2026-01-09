
 select 
account_id,

billing_address_line_1,
billing_address_line_2,
billing_city,

billing_state,
billing_zip,

account_division_id,
account_division_name,

account_old_id,
account_name,
account_name_2,
account_phone,


account_class_id,
account_class_name,

account_brokergroup_id,
account_broker_group_name,

account_billgroup_id,
account_billgroup_name,

account_manager_id,
account_manager_name,

account_source_id,
account_created_timestamp,
account_credit_limit,

account_term_id,
account_term_name,

account_warning_note,

account_source_name,
account_created_by_user,

account_status_effective_date,
account_status,
account_status_text,

 from {{ref('raw_navusoft__account_and_site')}}