select 
	date_trunc('month',date)::date as month,
	kpi_name,
	funnel_step,
	sum(deals_count) as deals_count
from "postgres"."test_pipedrive_analytics"."daily_activity_stats"
group by 
	month,
	kpi_name,
	funnel_step