with
    source as (
        select end_date, start_date, status, user_id
        from {{ source("google_sheets", "subscription") }}
    ),
    renamed as (
        select
            -- ids
            {{ adapter.quote("user_id") }},

            -- booleans
            case when status = 'active' then true else false end as is_active,

            -- dates
            {{ adapter.quote("start_date") }},
            {{ adapter.quote("end_date") }}
        from source
    )
select *
from renamed
