with
    source as (
        select created_at, email, user_id, username
        from {{ source("postgres", "user") }}
    ),
    renamed as (
        select
            {{ adapter.quote("user_id") }},
            {{ adapter.quote("username") }},
            {{ adapter.quote("email") }},
            {{ adapter.quote("created_at") }}

        from source
    )
select *
from renamed
