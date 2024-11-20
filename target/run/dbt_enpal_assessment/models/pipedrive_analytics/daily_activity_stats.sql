
  
    

  create  table "postgres"."public_pipedrive_analytics"."daily_activity_stats__dbt_tmp"
  
  
    as
  
  (
    with activity_base as 
(
select
    t1.deal_id,
    due_to::date as date,
    t2.name as kpi_name,
    case 
        when t2.name = 'Sales Call 1' then 'Step 2.1'
        when t2.name = 'Sales Call 2' then 'Step 3.1'
    end as funnel_step
from "postgres"."public"."activity"  t1
left join "postgres"."public"."activity_types"   t2
    on t1.type = t2.type
where 1=1 
    and t1.done = true
)
     
select 
	date,
	kpi_name,
	funnel_step,
	count(distinct deal_id) as deals_count
from activity_base
group by 
	date,
	kpi_name,
	funnel_step
  );
  