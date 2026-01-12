select

-- Identifiers / keys
id,
servicerecord_id,
servicerecordcharge_id,
workordernumber,
manifestconsolidationbatch_id,

-- Disposal / location references
disposallocation_id,
disposallocation_name,

-- Equipment / material
equipmenttype_id,
equipmenttype_name,
materialtype_id,
materialtype_name,

-- Units of measure
uom_id,
uom_name,

-- Weights / measurements
tareweight,
grossweight,
netweight,

-- Charges / codes
chargecode_id,
label,

-- Exception handling
exceptionreasoncode_id,
exception_approved,
exception_approved_user,

-- Operational / process metadata
manualentry,
receipttimestamp,
scanneduser_name

from {{ ref('raw_navusoft__work_order_label') }}