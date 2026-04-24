with 
    samsara_vehicle as (    
        select
            cast(id   as string) as samsara_vehicle_id,
            cast(name as string) as samsara_vehicle_name,
            {{ vehicle_map_name('name') }} as vehicle_map_name
        from {{ ref('raw_samsara__vehicle') }}
        where id is not null and name is not null
    ),

    navusoft_vehicle as (
        select distinct
            cast(truck_id   as string) as navusoft_vehicle_id,
            cast(truck_name as string) as navusoft_vehicle_name,
            {{ vehicle_map_name('truck_name') }} as vehicle_map_name
        from {{ ref('raw_navusoft__work_order') }}
        where truck_id is not null and truck_name is not null
    ),

    samsara_agg as (
    select
        vehicle_map_name,
        {{ agg_concat_distinct('samsara_vehicle_id')   }} as samsara_vehicle_id,
        {{ agg_concat_distinct('samsara_vehicle_name') }} as samsara_vehicle_name
    from samsara_vehicle
    group by vehicle_map_name
    ),

    navusoft_agg as (
    select
        vehicle_map_name,
        {{ agg_concat_distinct('navusoft_vehicle_id')   }} as navusoft_vehicle_id,
        {{ agg_concat_distinct('navusoft_vehicle_name') }} as navusoft_vehicle_name
    from navusoft_vehicle
    group by vehicle_map_name
    ),

    normalized_vehicle as (
        select
        coalesce(s.vehicle_map_name, n.vehicle_map_name) as vehicle_map_name,
        s.samsara_vehicle_id,
        s.samsara_vehicle_name,
        n.navusoft_vehicle_id,
        n.navusoft_vehicle_name,
        sysdate() as record_loaded_at,
        from samsara_agg s
        full outer join navusoft_agg n
        on s.vehicle_map_name = n.vehicle_map_name
    )

select * 
from normalized_vehicle
where vehicle_map_name is not null