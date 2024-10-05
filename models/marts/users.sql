with
postgres_activity as (select * from {{ ref("stg_postgres__activity") }}),
postgres_users as (select * from {{ ref("stg_postgres__user") }}),
salesforce_users as (select * from {{ ref('stg_salesforce__user') }}),

user_activities as (
    select
        user_id,
        count(*) as count_activity,
        count(case when activity_type = 'login' then 1 end) as count_login,
        count(case when activity_type = 'logout' then 1 end) as count_logout,
        count(case when activity_type = 'post' then 1 end) as count_post
    from postgres_activity
    group by user_id
),

final AS (
    SELECT
        user_id,
        user_activities.count_activity,
        user_activities.count_login,
        user_activities.count_logout,
        user_activities.count_post
    FROM postgres_users
    INNER JOIN salesforce_users USING (user_id)
    LEFT JOIN user_activities USING (user_id)
)

select *
from final
