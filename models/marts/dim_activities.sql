with
    activity as (
        select
            stg_postgres__activity.activity_date as activity_date,
            stg_postgres__activity.activity_description as activity_description,
            stg_postgres__activity.activity_id as activity_id,
            stg_postgres__activity.activity_type as activity_type,
            stg_postgres__activity.user_id as user_id
        from
            {{ ref('stg_postgres__activity') }}
            as stg_postgres__activity
    ),
    final as (
        select
            activity.activity_id
            as id,  /* ids */
            activity.user_id as user_id,
            activity.activity_type
            as type,  /* strings */
            activity.activity_description as description,
            date(activity.activity_date) as date  /* dates */
        from activity as activity
    )
select
    final.id as id,
    final.user_id as user_id,
    final.type as type,
    final.description as description,
    final.date as date
from final as final
