with salesforce_users as (
    select * from {{ ref("base_salesforce_users") }}
), postgres_user as (
    select * from {{ ref('base_public_user') }}
)

select *
from salesforce_users
left join postgres_user using (user_id, email)
