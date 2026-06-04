with 

samsara_base as (
    select
        id,
        name,
        {{clean_name('samsara')}} as clean_name
    from {{ref('raw_samsara__driver')}}
    where id is not null and name is not null
),

samsara_parts as (
    select
        *,
        split(clean_name, ' ') as p,
        array_size(split(clean_name, ' ')) as n
    from samsara_base
),

samsara_driver_map as (
    select
        id as samsara_driver_id,
        name samsara_driver_name,
        clean_name,
        p[0] as first_name,
        {{part_suffix()}} as suffix,
        {{part_last_name()}} as last_name,
        concat_ws(' ',first_name, last_name) driver_map_name
    from samsara_parts
    order by clean_name
),

navusoft_base as (
    select distinct
        cast(driver_id   as string) as navusoft_driver_id,
        cast(driver_name as string) as navusoft_driver_name,
        {{clean_name('navusoft')}} as clean_name
    from {{ref('raw_navusoft__work_order')}}
    where id is not null and driver_name is not null
),

navusoft_parts as (
    select
        *,
        split(clean_name, ' ') as p,
        array_size(split(clean_name, ' ')) as n
    from navusoft_base
),

navusoft_driver_map as (
    select
        navusoft_driver_id,
        navusoft_driver_name,
        clean_name,
        p[0] as first_name,
        {{part_suffix()}} as suffix,
        {{part_last_name()}} as last_name,
        concat_ws(' ',first_name, last_name) driver_map_name
    from navusoft_parts
),

adp_base_rate as (
    select
        uwm.id as navusoft_driver_id, 
        uwm.externalusrid as adp_driver_id, 
        w.associate_oid as adp_associate_id,
        wbr.hourly_rate_amount_amount_value as adp_hourly_rate 
    from {{ref('user_worker_mapping')}} uwm
    left join {{ref('raw_adp__worker_base_remuneration')}} wbr on wbr.worker_id = uwm.externalusrid
    left join {{ref('raw_adp__worker')}} w on w.id = uwm.externalusrid  
),


normalized_driver as (
    select
        coalesce(s.driver_map_name, n.driver_map_name) as driver_map_name,
        s.samsara_driver_id,
        s.samsara_driver_name,
        n.navusoft_driver_id,
        n.navusoft_driver_name,
        a.adp_driver_id,
        a.adp_associate_id,
        a.adp_hourly_rate,
        sysdate() as record_loaded_at,
    from samsara_driver_map s
    full outer join navusoft_driver_map n on s.driver_map_name = n.driver_map_name
    left join adp_base_rate a on n.navusoft_driver_id = a.navusoft_driver_id
),

normalized_driver as (

select
        coalesce(s.driver_map_name, n.driver_map_name) as driver_map_name,

        -- ✅ keep 1 samsara id (or aggregate if needed)
        min(s.samsara_driver_id) as samsara_driver_id,

        -- ✅ consolidate samsara names
        listagg(distinct s.samsara_driver_name, ', ') 
            within group (order by s.samsara_driver_name) 
            as samsara_driver_name,

        -- ✅ consolidate navusoft ids
        listagg(distinct n.navusoft_driver_id, ', ')
            within group (order by n.navusoft_driver_id)
            as navusoft_driver_id,

        -- ✅ consolidate navusoft names
        listagg(distinct n.navusoft_driver_name, ', ')
            within group (order by n.navusoft_driver_name)
            as navusoft_driver_name,

        -- ✅ ADP fields (choose appropriate behavior)
        min(a.adp_driver_id) as adp_driver_id,
        min(a.adp_associate_id) as adp_associate_id,
        max(a.adp_hourly_rate) as adp_hourly_rate,

        sysdate() as record_loaded_at

    from samsara_driver_map s
    full outer join navusoft_driver_map n 
        on s.driver_map_name = n.driver_map_name
    left join adp_base_rate a 
        on n.navusoft_driver_id = a.navusoft_driver_id

    where coalesce(s.driver_map_name, n.driver_map_name) is not null

    group by 1

)
select nd.*, 
from normalized_driver nd
    
