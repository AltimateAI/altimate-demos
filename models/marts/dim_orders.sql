WITH orders AS (
    SELECT 
        order_id,
        user_id,
        order_date,
        status,
        total_amount
    FROM {{ ref('stg_postgres__orders') }}
),

customers AS (
    SELECT 
        user_id,
        username,
        email,
        created_at
    FROM {{ ref('stg_postgres__user') }}
),

payments AS (
    SELECT 
        order_id,
        amount AS total_paid,
        payment_method AS payment_methods
    FROM {{ ref('stg_postgres__payments') }}
),

discounts AS (
    SELECT 
        order_id,
        SUM(discount_amount) AS total_discount
    FROM {{ ref('stg_salesforce__discounts') }}
    GROUP BY order_id
),

refunds AS (
    SELECT 
        order_id,
        SUM(refund_amount) AS total_refunded
    FROM {{ ref('stg_salesforce__refunds') }}
    GROUP BY order_id
),

final AS (
    SELECT 
        o.order_id,
        o.order_date,
        o.status,
        o.total_amount AS gross_revenue,
        COALESCE(d.total_discount, 0) AS total_discount,
        COALESCE(r.total_refunded, 0) AS total_refunded,
        (o.total_amount - COALESCE(d.total_discount, 0) - COALESCE(r.total_refunded, 0)) AS net_revenue,
        COALESCE(p.total_paid, 0) AS total_paid,
        COALESCE(p.payment_methods, "N/A") as payment_methods,
        c.email,
        c.username
    FROM orders o
    LEFT JOIN customers c ON o.user_id = c.user_id
    LEFT JOIN payments p ON o.order_id = p.order_id
    LEFT JOIN discounts d ON o.order_id = d.order_id
    LEFT JOIN refunds r ON o.order_id = r.order_id
)

SELECT * FROM final
