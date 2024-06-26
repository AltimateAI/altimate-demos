with activity as (
    select * from {{ ref('base_public_activity') }}
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
        activity_date as date
    from activity
)

select * from final
