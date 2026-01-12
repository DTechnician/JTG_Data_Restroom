{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='site_contract_status_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "site_contract_statuscontract_status",
    natural_key = ["id"],
    attributes = [
"expirationdate",
"contract_effective_date",
"type_id",
"proposalformtype_id",
"division_id",
"salesrep_id",
"site_id",
"term",
"renewaltermmonths",
"rate_guarantee_months",
"estimatedmonthlyrevenue",
"annual_increase_limit",
"site_name",
"division_name",
"salesrep_name",
"proposal_format_name",
"source",
    ],
    scd_type = 2
) }}