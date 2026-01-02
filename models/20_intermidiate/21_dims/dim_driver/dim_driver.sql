{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='driver_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "samsara",
    table_name = "driver",
    natural_key = ["id"],
    attributes = [
        "peer_group_tag_id",
        "eld_day_start_hour",
        "eld_exempt",
        "eld_pc_enabled",
        "timezone",
        "tachograph_card_number",
        "username",
        "external_id",
        "eld_big_day_exemption_enabled",
        "license_state",
        "license_number",
        "name",
        "locale",
        "eld_ym_enabled",
        "notes",
        "eld_adverse_weather_exemption_enabled",
        "current_id_card_code",
        "eld_exempt_reason",
        "carrier_settings_carrier_name",
        "carrier_settings_dot_number",
        "carrier_settings_home_terminal_address",
        "carrier_settings_home_terminal_name",
        "carrier_settings_main_office_address",
        "us_driver_ruleset_override_cycle",
        "us_driver_ruleset_override_restart",
        "us_driver_ruleset_override_break",
        "us_driver_ruleset_override_us_state_to_override"
    ],
    scd_type = 2
) }}
