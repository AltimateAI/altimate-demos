with activity as (
    select * from {{ ref('stg_postgres__activity') }}
),

final as (
    select
        -- ids
        activity_id as id,
        user_id,

        -- strings
        activity_type as type,
        activity_description as description,

        -- dates
        date(activity_date) as date
    from activity
)

select * from final
