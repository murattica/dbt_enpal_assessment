



select 
	due_date as date,
	kpi_name,
	funnel_step,
	count(distinct case when done = true then deal_id end) as deals_count
from "postgres"."pipedrive_analytics_staging"."activity_staging"  
where 1=1
	
	and due_date >= '2024-11-19'::date - 7
	
group by 
	date,
	kpi_name,
	funnel_step