with users as (
    select * from {{ ref('dim_users') }}
), activities as (
    select * from {{ ref('dim_activities') }}
),

final as (
    select
        users.email,
        activities.type,

        count(*) as number_of_activities,
        max(activities.date) as last_activity_date
    from users
    left join activities using (user_id)
    group by users.email, activities.type
)

select * from final
