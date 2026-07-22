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
        select id as worker_id, w.associate_oid, lwa.latest_job_title, ph.legal_name_formatted_name, ph.legal_name_family_name_1, ph.legal_name_given_name
        from {{ref('raw_adp__worker')}} w
        join adp_latest_worker_assignment lwa on w.id = lwa.worker_id
        left join adp_person_history ph on w.id = ph.worker_id
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

    adp_navusoft_driver_mapping as (
        select EXTERNALUSRID as adp_worker_id, nd.navusoft_driver_id, nd.navusoft_driver_name,
        from {{ref('user_worker_mapping')}} uwm
        join navusot_driver nd on uwm.id = nd.navusoft_driver_id
        where EXTERNALUSRID is not null
    )
    

-- select * from adp_base_driver where id is null;

select  
    adp_d.associate_oid,
    latest_job_title as job_title,
    legal_name_formatted_name as driver_name,
    legal_name_family_name_1 as driver_last_name,
    legal_name_family_name_1 as driver_given_name,
    adp_worker_id as adp_driver_id,
    navusoft_driver_id,
    -- null as samsara_drvier_id,
   case when navusoft_driver_id is null then 'UNMAPPED' else 'MAPPED' end as mapping_ind,
from adp_base_driver adp_d
left join adp_navusoft_driver_mapping an_map on adp_d.worker_id = an_map.adp_worker_id