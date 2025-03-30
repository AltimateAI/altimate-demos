with source as (
        select * from {{ source('salesforce', 'refunds') }}
  ),
  renamed as (
      select
          {{ adapter.quote("order_id") }},
        {{ adapter.quote("refund_amount") }}

      from source
  )
  select * from renamed
    