with
    users as (select * from {{ ref("dim_users") }}),
    activities as (select * from {{ ref("dim_activities") }}),

    number_of_activities as (
        select
            date as day,
            count(*) as number_activities,
            sum(case when type = 'login' then 1 else 0 end) as number_logins,
            sum(case when type = 'logout' then 1 else 0 end) as number_logouts,
            sum(case when type = 'post' then 1 else 0 end) as number_posts
        from activities
        group by day
    ), number_of_users as (
        select
            created_date as day,
            count(*) as number_users
        from users
        group by day
    ),

    final as (
        select
            day,

            number_users,
            number_activities
        from number_of_users
        left join number_of_activities using (day)
    )

select *
from final
