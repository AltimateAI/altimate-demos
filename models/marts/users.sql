with
    salesforce_users as (
        select
            user_id,
            email,
            first_name,
            last_name,
            phone,
            address,
            is_active,
            last_contacted_date,
            created_date,
            modified_date
        from {{ ref("base_salesforce_users") }}
    ),
    postgres_users as (
        select user_id, username, created_at from {{ ref("base_public_user") }}
    )

select
    salesforce_users.user_id,
    salesforce_users.email,

    postgres_users.username,
    salesforce_users.first_name,
    salesforce_users.last_name,
    salesforce_users.phone,
    salesforce_users.address,

    salesforce_users.is_active,

    salesforce_users.last_contacted_date,
    salesforce_users.created_date,
    salesforce_users.modified_date,

    postgres_users.created_at
from salesforce_users
left join postgres_users on salesforce_users.user_id = postgres_users.user_id
