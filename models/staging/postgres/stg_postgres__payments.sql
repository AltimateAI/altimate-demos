with source as (
        select *
        from {{ source(
          'postgres',
          'payments'
        ) }}
  ),
  renamed as (
      select
        {{ adapter.quote("order_id") }},
        {{ adapter.quote("amount") }},
        {{ adapter.quote("payment_method") }}

      from source
  )
  select * from renamed
    