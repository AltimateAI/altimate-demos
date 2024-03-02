with source as (
    select * from {{ source('public', 'activity') }}
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
select * from renamed
  