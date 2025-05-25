with
    orders as (
        select
            stg_postgres__orders.order_id as order_id,
            stg_postgres__orders.user_id as user_id,
            stg_postgres__orders.order_date as order_date,
            stg_postgres__orders.status as status,
            stg_postgres__orders.total_amount as total_amount
        from {{ ref("stg_postgres__orders") }} as stg_postgres__orders
    ),
    customers as (
        select
            stg_postgres__user.user_id as user_id,
            stg_postgres__user.username as username,
            stg_postgres__user.email as email
        from {{ ref("stg_postgres__user") }} as stg_postgres__user
    ),
    payments as (
        select
            stg_postgres__payments.order_id as order_id,
            stg_postgres__payments.amount as total_paid,
            stg_postgres__payments.payment_method as payment_methods
        from {{ ref("stg_postgres__payments") }} as stg_postgres__payments
    ),
    discounts as (
        select
            stg_salesforce__discounts.order_id as order_id,
            sum(stg_salesforce__discounts.discount_amount) as total_discount
        from {{ ref("stg_salesforce__discounts") }} as stg_salesforce__discounts
        group by stg_salesforce__discounts.order_id
    ),
    refunds as (
        select
            stg_salesforce__refunds.order_id as order_id,
            sum(stg_salesforce__refunds.refund_amount) as total_refunded
        from {{ ref("stg_salesforce__refunds") }} as stg_salesforce__refunds
        group by stg_salesforce__refunds.order_id
    ),
    final as (
        select
            o.order_id as order_id,
            o.order_date as order_date,
            o.status as status,
            o.total_amount as gross_revenue,
            coalesce(d.total_discount, 0) as total_discount,
            coalesce(r.total_refunded, 0) as total_refunded,
            (
                o.total_amount
                - coalesce(d.total_discount, 0)
                - coalesce(r.total_refunded, 0)
            ) as net_revenue,
            coalesce(p.total_paid, 0) as total_paid,
            coalesce(p.payment_methods, 'N/A') as payment_methods,
            c.email as email,
            c.username as username
        from orders as o
        left join customers as c on o.user_id = c.user_id
        left join payments as p on o.order_id = p.order_id
        left join discounts as d on o.order_id = d.order_id
        left join refunds as r on o.order_id = r.order_id
    )
select
    final.order_id as order_id,
    final.order_date as order_date,
    final.status as status,
    final.gross_revenue as gross_revenue,
    final.total_discount as total_discount,
    final.total_refunded as total_refunded,
    final.net_revenue as net_revenue,
    final.total_paid as total_paid,
    final.payment_methods as payment_methods,
    final.email as email,
    final.username as username
from final as final
