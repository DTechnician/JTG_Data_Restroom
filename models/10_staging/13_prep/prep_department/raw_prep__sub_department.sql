with list_department as (
    select distinct 
        ou.name department_code, coalesce(ou.name_short_name, ou.name_long_name) sub_department_name, 
        ou.name sub_department_code,
        sysdate() as record_loaded_at,
    from {{ref('raw_adp__worker_home_organizational_unit')}} whou
    join {{ref('raw_adp__organizational_unit')}} ou on whou.id = ou.id
    where type_short_name = 'Department'
    order by 1
)

select * from list_department