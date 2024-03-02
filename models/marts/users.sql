with
postgres_activity as (select * from {{ ref("stg_postgres__activity") }}),
postgres_users as (select * from {{ ref("stg_postgres__user") }}),
salesforce_users as (select * from {{ ref('stg_salesforce__user') }}),

user_activities as (
    select
        user_id,
        count(*) as count_activity
    from postgres_activity
    group by user_id
),

final as (
    select
        user_id,

        salesforce_users.first_name,
        salesforce_users.last_name,
        salesforce_users.email,
        salesforce_users.phone,
        salesforce_users.address,
        salesforce_users.last_contacted_date,
        salesforce_users.created_date,
        salesforce_users.modified_date,

        user_activities.count_activity
    from postgres_users
    inner join salesforce_users using (user_id)
    left join user_activities using (user_id)
)

select *
from final
