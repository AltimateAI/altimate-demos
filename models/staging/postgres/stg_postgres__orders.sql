with source as (
        select * from {{ source('postgres', 'orders') }}
  ),
  renamed as (
      select
          {{ adapter.quote("id") }} as order_id,
        cast({{ adapter.quote("user_id") }} as int) as user_id,
        {{ adapter.quote("order_date") }},
        {{ adapter.quote("status") }},
        {{ adapter.quote("total_amount") }}

      from source
  )
  select * from renamed
    