with
    users as (
        select dim_users.created_date as created_date
        from {{ ref("dim_users") }} as dim_users
    ),
    activities as (
        select dim_activities.date as date, dim_activities.type as type
        from {{ ref("dim_activities") }} as dim_activities
    ),
    number_of_activities as (
        select
            activities.date as day,
            sum(case when activities.type = 'login' then 1 else 0 end) as number_logins
        from activities as activities
        group by activities.date
    ),
    number_of_users as (
        select users.created_date as day, count(*) as number_users
        from users as users
        group by users.created_date
    ),
    final as (
        select
            coalesce(number_of_users.day, number_of_activities.day) as day,
            number_of_users.number_users as number_users,
            number_of_activities.number_logins as number_logins
        from number_of_users as number_of_users
        left join
            number_of_activities as number_of_activities
            on number_of_users.day = number_of_activities.day
    )
select
    final.day as day,
    final.number_users as number_users,
    final.number_logins as number_logins
from final as final
