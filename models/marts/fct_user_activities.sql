with users as (
    select * from {{ ref('dim_users') }}
), activities as (
    select * from {{ ref('base_public_activity') }}
),

final as (
    select
        users.email,
        activities.activity_type,

        count(*) as number_of_activities,
        max(activity_date) as last_activity_date
    from users
    left join activities using (user_id)
    group by email, activity_type
)

select * from final
