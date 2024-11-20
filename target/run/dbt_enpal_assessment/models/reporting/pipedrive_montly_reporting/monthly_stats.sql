
  
    

  create  table "postgres"."reports"."monthly_stats__dbt_tmp"
  
  
    as
  
  (
    select 
	month,
	kpi_name,
	funnel_step,
    deals_count
from "postgres"."reports"."monthly_deal_stats" 
where field = 'stage_id'

union all 

select 
	month,
	kpi_name,
	funnel_step,
    deals_count
from "postgres"."reports"."monthly_activity_stats"
where kpi_name in ('Sales Call 1', 'Sales Call 2')
  );
  