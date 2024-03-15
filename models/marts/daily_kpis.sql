with
    users as (select * from {{ ref("users") }}),
    subscription as (select * from {{ ref("base_google_sheets_subscription") }}),
    activities as (select * from {{ ref("base_public_activity") }}),

    number_of_activities as (
        select
            current_date as day,
            count(*) as number_activities,
            sum(case when activity_type = 'login' then 1 else 0 end) as number_logins,
            sum(case when activity_type = 'logout' then 1 else 0 end) as number_logouts,
            sum(case when activity_type = 'post' then 1 else 0 end) as number_posts
        from activities
        where date(activity_date) = current_date
    ), number_of_users as (
        select
            current_date as day,
            count(*) as number_users,
            count(case when current_date = date(last_contacted_date) then 1 end) as contacted_today
        from users
    ), number_of_active_subscriptions as (
        select
            current_date as day,
            count(case when status = 'active' then 1 end) as number_active_subscriptions
        from subscription
    ),

    final as (
        select
            day,

            number_users,
            number_active_subscriptions,
            number_activities,
            number_logins,
            number_logouts,
            number_posts,
            contacted_today
        from number_of_users
        left join number_of_active_subscriptions using (day)
        left join number_of_activities using (day)
    )

select *
from final
