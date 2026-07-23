with 
    adp_person_history as (
        SELECT *
        FROM {{ref('raw_adp__person_history')}}
        -- where worker_id ='E3KSMVIGX'
        QUALIFY ROW_NUMBER() OVER (
            PARTITION BY worker_id
            ORDER BY _fivetran_synced DESC
        ) = 1
    ),

    adp_latest_worker_assignment as (
        select worker_id, job_title as latest_job_title
        from {{ref('raw_adp__work_assignment_history')}}
        where lower(job_title) like '%driver%'
        QUALIFY ROW_NUMBER() OVER (
            PARTITION BY worker_id
            ORDER BY ASSIGNMENT_STATUS_EFFECTIVE_DATE DESC
        ) = 1
    ),
    
    adp_base_driver as (
        select id as worker_id, w.associate_oid, lwa.latest_job_title, ph.legal_name_formatted_name, ph.legal_name_family_name_1, ph.legal_name_given_name, wbr.hourly_rate_amount_amount_value as hourly_rate
        from {{ref('raw_adp__worker')}} w
        join adp_latest_worker_assignment lwa on w.id = lwa.worker_id --inner join to remove non driver workers from ADP
        left join adp_person_history ph on w.id = ph.worker_id
        left join {{ref('raw_adp__worker_base_remuneration')}} wbr on w.id = wbr.worker_id
        -- where status_value = 'Active'
    ),

-----------------------------------NAVUSOFT DRIVER RECORDS
    
     navusot_driver as (
        select distinct
            cast(driver_id   as string) as navusoft_driver_id,
            cast(driver_name as string) as navusoft_driver_name,
        from {{ref('raw_navusoft__work_order')}}
        where id is not null and driver_name is not null
    ),

    driver_mapping as (
        select adp_driver_id, navusoft_driver_id, 
        from {{ref('driver_mapping')}} uwm
    ),

    

-- select * from adp_base_driver where id is null;

    final as (
        select  
            adp_d.associate_oid,
            upper(latest_job_title) as job_title,
            upper(concat(legal_name_given_name,' ',legal_name_family_name_1)) as driver_name,
            upper(legal_name_family_name_1) as driver_last_name,
            upper(legal_name_given_name) as driver_given_name,
            adp_d.adp_driver_id,
            d_map.navusoft_driver_id,
            adp_d.hourly_rate,
            sysdate() as record_loaded_at,
            -- null as samsara_drvier_id,
        from adp_base_driver adp_d
        left join driver_mapping d_map on adp_d.worker_id = d_map.adp_driver_id
    )

select *
from final