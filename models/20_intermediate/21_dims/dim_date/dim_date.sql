{{ config(
    materialized='table'
) }}

with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="to_date('2015-01-01')",
        end_date="to_date('2035-12-31')"
    ) }}

),

final as (

    select
        -- Surrogate Key (numeric-friendly YYYYMMDD)
        to_number(to_char(date_day, 'YYYYMMDD')) as date_sk,

        date_day as date,

        -- Basic attributes
        extract(year  from date_day) as year,
        extract(quarter from date_day) as quarter,
        extract(month from date_day) as month,
        extract(day   from date_day) as day_of_month,

        -- Day attributes
        extract(dow from date_day) as day_of_week,
        to_char(date_day, 'Day') as day_name,
        to_char(date_day, 'Dy')  as day_name_short,

        -- Month attributes
        to_char(date_day, 'Month') as month_name,
        to_char(date_day, 'Mon')   as month_name_short,

        -- ISO / business analytics
        weekofyear(date_day) as week_of_year,
        extract(dayofyear from date_day) as day_of_year,

        -- Flags
        case when extract(dow from date_day) in (0,6) then true else false end as is_weekend,
        case when date_day = current_date then true else false end as is_today

    from date_spine

)

select *
from final
