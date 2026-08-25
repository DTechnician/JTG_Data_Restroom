/*This bridge table is created to apply the relationship between dim_department and dim_site_division*/

with 
    division_department_mapping as (
        select * 
        from {{ref('division_department_mapping')}} 
    ),

    dim_site_division as (
        select * 
        from {{ref('dim_site_division')}}
    ),

    dim_department as (
        select * 
        from {{ref('dim_department')}}
    ),

    bridge__department_division as (
        select distinct
            dd.department_sk,
            dsd.site_division_sk,
            ddm.allocation_pct,
        from dim_department dd
        join division_department_mapping ddm on dd.department_code = ddm.department_code
        join  dim_site_division dsd on ddm.site_division_id = dsd.site_division_id
    )

select * from bridge__department_division