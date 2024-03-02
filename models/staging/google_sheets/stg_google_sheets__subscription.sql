with source as (
      select * from {{ source('google_sheets', 'subscription') }}
),
renamed as (
    select
        {{ adapter.quote("user_id") }},
        {{ adapter.quote("start_date") }},
        {{ adapter.quote("end_date") }},
        {{ adapter.quote("status") }}

    from source
)
select * from renamed
  