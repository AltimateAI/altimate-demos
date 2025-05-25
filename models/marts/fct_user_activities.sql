with
    users as (
        select dim_users.email as email, dim_users.user_id as user_id
        from {{ ref("dim_users") }} as dim_users
    ),
    activities as (
        select
            dim_activities.date as date,
            dim_activities.type as type,
            dim_activities.user_id as user_id
        from {{ ref("dim_activities") }} as dim_activities
    ),
    final as (
        select
            users.email as email,
            activities.type as type,
            count(*) as number_of_activities,
            max(activities.date) as last_activity_date
        from users as users
        left join activities as activities on users.user_id = activities.user_id
        group by users.email, activities.type
    )
select
    final.email as email,
    final.type as type,
    final.number_of_activities as number_of_activities,
    final.last_activity_date as last_activity_date
from final as final
