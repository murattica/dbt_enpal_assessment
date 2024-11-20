select
    t1.deal_id,
    due_to::date as due_date,
    t2.name as kpi_name,
    case 
        when t2.name = 'Sales Call 1' then 'Step 2.1'
        when t2.name = 'Sales Call 2' then 'Step 3.1'
    end as funnel_step,
    done
from {{ source('postgres_public','activity') }}  t1
left join {{ source('postgres_public','activity_types') }}   t2
    on t1.type = t2.type
where 1=1 
    