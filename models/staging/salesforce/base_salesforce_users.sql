with source as (
      select * from {{ source('salesforce', 'users') }}
),
renamed as (
    select
        {{ adapter.quote("user_id") }},
        {{ adapter.quote("first_name") }},
        {{ adapter.quote("last_name") }},
        {{ adapter.quote("email") }},
        {{ adapter.quote("phone") }},
        {{ adapter.quote("address") }},
        {{ adapter.quote("last_contacted_date") }},
        {{ adapter.quote("created_date") }},
        {{ adapter.quote("modified_date") }},
        {{ adapter.quote("is_active") }}

    from source
)
select * from renamed
  