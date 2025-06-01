with
    source as (
        select activity_date, activity_description, activity_id, activity_type, user_id
        from {{ source("postgres", "activity_partitioned") }}
    ),
    renamed as (
        select
            {{ adapter.quote("activity_id") }},
            {{ adapter.quote("user_id") }},
            {{ adapter.quote("activity_type") }},
            {{ adapter.quote("activity_date") }},
            {{ adapter.quote("activity_description") }}

        from source
    )
select *
from renamed
