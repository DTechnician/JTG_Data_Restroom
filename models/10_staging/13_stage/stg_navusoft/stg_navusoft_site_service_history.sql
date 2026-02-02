{{ config(materialized='view') }}

select distinct
    start_date,
    -- end_date,
    billed_thru_date,
    site_division_id,
    service_id,
    start_posted_timestamp,
    -- end_posted_timestamp,
    quantity,
    perunitrate,
    rate,
    site_id,
    site_name,
    site_address_line_1,
    site_address_line_2,
    site_city,
    site_state,
    site_zip,
    start_reason_code,
    start_user_name,
    end_reason_code,
    -- end_user_name,
    service_code_id,
    service_code_name,
    lob_id,
    lob_name,
    equipmenttype_id,
    equipmenttype_name,
    ssh.service_frequency,
    lost_to_competitor_id,
    lost_to_competitor_name,
    -- payload_hash,
    rn,

    sfm.sf_value,
    rate/sfm.sf_value as calculated_revenue,

    /* duration */
    case
        when start_date is not null
         and end_date   is not null
         and end_date   >= start_date
        then datediff(minute, start_date, end_date)
        else null
    end as service_duration_minutes,
    
from {{ref('raw_navusoft__site_service_history')}} ssh
left join {{ref('service_frequency_mapping')}} sfm on ssh.service_frequency = sfm.service_frequency
