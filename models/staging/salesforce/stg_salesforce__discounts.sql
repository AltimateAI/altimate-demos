with source as (
        select * from {{ source('salesforce', 'discounts') }}
  ),
  renamed as (
      select
        {{ adapter.quote("order_id") }},
        {{ adapter.quote("discount_amount") }}

      from source
  )
  select * from renamed
    