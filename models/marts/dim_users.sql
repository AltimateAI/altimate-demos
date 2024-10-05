with
    salesforce_users as (select * from {{ ref("base_salesforce_users") }}),
    postgres_users as (select * from {{ ref("base_public_user") }}),

    users_info as (
        select
            salesforce_users.user_id,
            salesforce_users.email,

            postgres_users.username,
            concat(salesforce_users.first_name, ' ', salesforce_users.last_name) as name,
            salesforce_users.phone,
            salesforce_users.address,

            salesforce_users.is_active,

            salesforce_users.last_contacted_date,
            salesforce_users.created_date,
            salesforce_users.modified_date,

            postgres_users.created_at
        from salesforce_users
        left join postgres_users using (user_id)
        where salesforce_users.is_active
    ),

    final as (
        select
            users_info.user_id,
            users_info.email,

            users_info.username,
            users_info.name,
            users_info.phone,
            users_info.address,

            users_info.is_active,

            users_info.last_contacted_date,
            users_info.created_date,
            users_info.modified_date,

            users_info.created_at
        from users_info
    )

select *
from final
