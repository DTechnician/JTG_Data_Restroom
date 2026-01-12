select

-- Identifiers / keys
contact_id,
contact_uuid,
contact_entity_id,
entitytype_id,
contact_entity_type,

-- Account / site / division context
account_id,
site_id,
division_id,
division_name,
serviceregion_id,
serviceregion_name,

-- Contact identity
contact_name,
contact_title,
contact_email,
contact_phone,

-- Contact roles
contactrole_id1,
contactrole_id2,
contact_role1_name,
contact_role2_name,

-- Notification preferences
receive_service_notifications,
service_notification_method,
ar_notification_method,

-- Status / lifecycle
status,
status_text,
last_updated_time,

-- Additional descriptive fields
name,
name2,
contact_note

from {{ ref('raw_navusoft__contact_information') }}