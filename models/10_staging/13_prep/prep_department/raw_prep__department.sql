with 
    division_department_mapping as (
        select * ,
        
            sysdate() as record_loaded_at,
        from {{ref('division_department_mapping')}}
    )

select * 
from division_department_mapping