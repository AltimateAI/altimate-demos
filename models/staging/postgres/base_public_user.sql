with source as (
      select * from {{ source('public', 'user') }}
),
renamed as (
    select
        {{ adapter.quote("user_id") }},
        {{ adapter.quote("username") }},
        {{ adapter.quote("email") }},
        {{ adapter.quote("created_at") }}

    from source
)
select * from renamed
  