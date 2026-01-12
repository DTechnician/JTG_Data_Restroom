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
    natural_key = ["contact_id", "contact_entity_id"],
    attributes = [
"contact_uuid",
"entitytype_id",
"contact_entity_type",
"account_id",
"site_id",
"division_id",
"division_name",
"serviceregion_id",
"serviceregion_name",
"contact_name",
"contact_title",
"contact_email",
"contact_phone",
"contactrole_id1",
"contactrole_id2",
"contact_role1_name",
"contact_role2_name",
"receive_service_notifications",
"service_notification_method",
"ar_notification_method",
"status",
"status_text",
"last_updated_time",
"name",
"name2",
"contact_note",
    ],
    scd_type = 2
) }}