with 
    raw_navusoft__account_and_site as (
        select 
            distinct
            account_status_text,
            account_id,
            account_broker_group_name,
            account_credit_limit,
            account_term_name,
            account_phone,
            account_billgroup_id,
            account_class_name,
            account_status,
            account_brokergroup_id,
            account_division_name,
            account_warning_note,
            account_manager_id,
            parentaccount_id,
            account_manager_name,
            parentaccountname,
            account_status_effective_date,
            account_class_id,
            account_source_id,
            account_created_timestamp,
            account_created_by_user,
            account_billgroup_name,
            account_source_name,
            account_name,
            account_name_2,
            account_old_id,
            account_division_id,
            account_term_id,
            INGESTED_AT,
            from {{ref('raw_navusoft__account_and_site')}}
        )

    select *
    from raw_navusoft__account_and_site