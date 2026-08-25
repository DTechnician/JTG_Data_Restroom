/*This bridge table is created to apply the relationship between dim_department and dim_site_division*/

with 
    division_department_mapping as (
        select * 
        from {{ref('division_department_mapping')}}
    ),

    dim_sub_department as (
        select * 
        from {{ref('dim_sub_department')}}
    ),

    dim_department as (
        select * 
        from {{ref('dim_department')}}
    ),

    bridge__department_division as (
        select distinct
            dd.department_sk,
            dsd.sub_department_sk,
            ddm.allocation_pct,
        from dim_department dd
        join division_department_mapping ddm on dd.department_code = ddm.department_code
        join  dim_sub_department dsd on ddm.sub_department_code = dsd.sub_department_code
    )

select * from bridge__department_division