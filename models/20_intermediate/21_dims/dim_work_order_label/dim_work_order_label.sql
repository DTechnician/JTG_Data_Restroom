{{ config(
    materialized='incremental',
    tag='dims',
    unique_key='work_order_label_sk',
    incremental_strategy='merge',
    merge_update_columns=['is_current', 'valid_to']
) }}

{{ generate_dimension(
    source = "navusoft",
    table_name = "work_order_label",
    natural_key = ["id"],
    attributes = [
"servicerecord_id",
"servicerecordcharge_id",
"workordernumber",
"manifestconsolidationbatch_id",
"disposallocation_id",
"disposallocation_name",
"equipmenttype_id",
"equipmenttype_name",
"materialtype_id",
"materialtype_name",
"uom_id",
"uom_name",
"tareweight",
"grossweight",
"netweight",
"chargecode_id",
"label",
"exceptionreasoncode_id",
"exception_approved",
"exception_approved_user",
"manualentry",
"receipttimestamp",
"scanneduser_name",
    ],
    scd_type = 2
) }}