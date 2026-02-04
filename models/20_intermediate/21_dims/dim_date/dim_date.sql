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
<<<<<<< HEAD
        -- Surrogate Key
=======
        -- Surrogate Key (numeric-friendly YYYYMMDD)
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
        to_number(to_char(date_day, 'YYYYMMDD')) as date_sk,

        date_day as date,

        -- Basic attributes
<<<<<<< HEAD
        year(date_day)    as year,
        quarter(date_day) as quarter,
        month(date_day)   as month,
        day(date_day)     as day_of_month,

        concat(year(date_day), '0', quarter(date_day)) as year_quarter_id,
        concat(year(date_day), to_char(date_day, 'MM')) as year_month_id,
																																													

        /* ===========================
           Sunday-based week logic
        ============================ */
							 
							   
							  
							
							  
										 
												   

        -- Sunday = 1, Saturday = 7
        dayofweek(date_day) as day_of_week_sun,

        -- Week start (Sunday)
        dateadd(
            day,
            -(dayofweek(date_day) - 1),
            date_day
        ) as week_start_date_sun,

        -- Week end (Saturday)
        dateadd(
            day,
            6,
            dateadd(
                day,
                -(dayofweek(date_day) - 1),
                date_day
            )
        ) as week_end_date_sun,

        -- Sunday-based week number
        weekofyear(
            dateadd(
                day,
                -(dayofweek(date_day) - 1),
                date_day
            )
        ) as week_of_year_sun,

        -- Year-week key (Sunday-based)
        concat(
            year(
                dateadd(
                    day,
                    -(dayofweek(date_day) - 1),
                    date_day
                )
            ),
            lpad(
                weekofyear(
                    dateadd(
                        day,
                        -(dayofweek(date_day) - 1),
                        date_day
                    )
                ),
                2,
                '0'
            )
        ) as year_week_id_sun,

        /* ===========================
           Day names (corrected)
        ============================ */

        decode(
            dayofweek(date_day),
            1, 'Sunday',
            2, 'Monday',
            3, 'Tuesday',
            4, 'Wednesday',
            5, 'Thursday',
            6, 'Friday',
            7, 'Saturday'
        ) as day_name,

        to_char(date_day, 'Dy') as day_name_short,

        /* ===========================
           Month attributes
        ============================ */

        to_char(date_day, 'MMMM') as month_name,
        to_char(date_day, 'Mon')  as month_name_short,

        /* ===========================
           Analytics helpers
        ============================ */
											 
														

        concat('Qtr ', quarter(date_day)) as quarter_name,
        concat('Wk ', week_of_year_sun)   as week_of_year_name,
        dayofyear(date_day)               as day_of_year,

        /* ===========================
           Flags
        ============================ */

        case
            when dayofweek(date_day) in (1,7) then true
            else false
        end as is_weekend,

        case
            when date_day = current_date then true
            else false
        end as is_today
=======
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
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b

    from date_spine

)

select *
<<<<<<< HEAD
from final
=======
from final
>>>>>>> da8821afc7bbbdfb39fbfc68c3eb6ce1bdad1e3b
