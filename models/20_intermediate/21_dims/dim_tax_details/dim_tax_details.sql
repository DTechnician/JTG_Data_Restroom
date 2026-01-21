{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='tax_details_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "tax_details",
    natural_key = ["invoiceid","accountid","siteid","taxregionid","lob_id"],
    attributes = [
"taxexempt",
"divisionId",
"totalsales",
"taxablerevenue",
"taxes",
"divisionname",
"accountname",
"sitename",
"addressline1",
"addressline2",
"city",
"state",
"period_id",
"tax_name",
"tax_authority_code",
"tax_authority_type_name",
"creditglaccount_id",
"debitglaccount_id",
"lob_name",
    ],
    scd_type = 2
) }}