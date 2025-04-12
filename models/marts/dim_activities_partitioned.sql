{% set partitions_to_replace = [
  'current_date',
  'date_sub(current_date, interval 1 day)'
] %}

{{
  config(
    materialized = 'incremental',
    incremental_strategy = 'insert_overwrite',
    partition_by = {'field': 'date', 'data_type': 'date'},
    partitions = partitions_to_replace
  )
}}

with activity as (
    select * from {{ ref('stg_postgres__activity') }}
    {% if is_incremental() %}
        where date(activity_date) in ({{ partitions_to_replace | join(',') }})
    {% endif %}
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
