{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='contact_information_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "contact_information",
    natural_key = ["contact_id"],
    attributes = [
        "entitytype_id",
        "status",
        "contactrole_id1",
        "contactrole_id2",
        "division_id",
        "account_id",
        "last_updated_time",
        "contact_entity_id",
        "site_id",
        "contact_uuid",
        "contact_name",
        "contact_title",
        "contact_email",
        "contact_phone",
        "contact_note",
        "contact_role1_name",
        "contact_role2_name",
        "receive_service_notifications",
        "service_notification_method",
        "ar_notification_method",
        "contact_entity_type",
        "division_name",
        "name",
        "name2",
        "serviceregion_id",
        "serviceregion_name",
        "status_text"
    ],
    scd_type = 2
) }}