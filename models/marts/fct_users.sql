
select
    created_at::date as created_date,
    count(*) as count_users
from postgres.user
group by created_date;
