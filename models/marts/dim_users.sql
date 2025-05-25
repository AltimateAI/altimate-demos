with
    salesforce_users as (
        select
            base_salesforce_users.address as address,
            base_salesforce_users.created_date as created_date,
            base_salesforce_users.email as email,
            base_salesforce_users.first_name as first_name,
            base_salesforce_users.is_active as is_active,
            base_salesforce_users.last_contacted_date as last_contacted_date,
            base_salesforce_users.last_name as last_name,
            base_salesforce_users.modified_date as modified_date,
            base_salesforce_users.phone as phone,
            base_salesforce_users.user_id as user_id
        from
            {{ ref('base_salesforce_users') }}
            as base_salesforce_users
    ),
    postgres_users as (
        select
            stg_postgres__user.created_at as created_at,
            stg_postgres__user.user_id as user_id,
            stg_postgres__user.username as username
        from
            {{ ref('stg_postgres__user') }}
            as stg_postgres__user
    ),
    activities as (
        select stg_postgres__activity.user_id as user_id
        from
            {{ ref('stg_postgres__activity') }} as stg_postgres__activity
    ),
    activity_by_user as (
        select activities.user_id as user_id, count(*) as number_of_activities
        from activities as activities
        group by activities.user_id
    ),
    users_info as (
        select
            salesforce_users.user_id as user_id,
            salesforce_users.email as email,
            postgres_users.username as username,
            concat(
                salesforce_users.first_name, ' ', salesforce_users.last_name
            ) as name,
            salesforce_users.phone as phone,
            salesforce_users.address as address,
            salesforce_users.is_active as is_active,
            salesforce_users.last_contacted_date as last_contacted_date,
            date(salesforce_users.created_date) as created_date,
            salesforce_users.modified_date as modified_date,
            postgres_users.created_at as created_at
        from salesforce_users as salesforce_users
        left join
            postgres_users as postgres_users
            on salesforce_users.user_id = postgres_users.user_id
        where salesforce_users.is_active
    ),
    final as (
        select
            users_info.user_id as user_id,
            users_info.email as email,
            users_info.username as username,
            users_info.name as name,
            users_info.phone as phone,
            users_info.address as address,
            activity_by_user.number_of_activities as number_of_activities,
            users_info.is_active as is_active,
            users_info.last_contacted_date as last_contacted_date,
            users_info.created_date as created_date,
            users_info.modified_date as modified_date,
            users_info.created_at as created_at
        from users_info as users_info
        left join
            activity_by_user as activity_by_user
            on users_info.user_id = activity_by_user.user_id
    )
select
    final.user_id as user_id,
    final.email as email,
    final.username as username,
    final.name as name,
    final.phone as phone,
    final.address as address,
    final.number_of_activities as number_of_activities,
    final.is_active as is_active,
    final.last_contacted_date as last_contacted_date,
    final.created_date as created_date,
    final.modified_date as modified_date,
    final.created_at as created_at
from final as final
