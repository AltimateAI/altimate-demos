with
    source as (
        select order_id, refund_amount from {{ source("salesforce", "refunds") }}
    ),
    renamed as (select order_id, refund_amount from source)
select *
from renamed
