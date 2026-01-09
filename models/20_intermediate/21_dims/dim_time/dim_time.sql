{{ config(
    materialized='table'
) }}

with minutes as (

    -- Generate 0–1439 minutes in a day
    select
        row_number() over(order by seq4()) - 1 as minute_of_day
    from table(generator(rowcount => 1440))

),

final as (

    select
        -- Surrogate Key (numeric, BI-friendly)
        minute_of_day as time_sk,

        -- Core time values
        floor(minute_of_day / 60) as hour,
        mod(minute_of_day, 60)    as minute,

        -- Formatted values
        lpad(floor(minute_of_day / 60)::varchar, 2, '0')
            || ':' ||
        lpad(mod(minute_of_day, 60)::varchar, 2, '0')
            as time_hhmm,

        -- Day parts
        case
            when minute_of_day between 0 and 359   then 'Night'
            when minute_of_day between 360 and 719 then 'Morning'
            when minute_of_day between 720 and 1079 then 'Afternoon'
            else 'Evening'
        end as day_part,

        -- Flags
        case when minute_of_day between 480 and 1019 then true else false end
            as is_business_hours

    from minutes

)

select *
from final
