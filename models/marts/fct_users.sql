
select
    date(created_at) as created_date,
    count(*) as count_users
from {{ ref('stg_postgres__user') }}
group by created_date
