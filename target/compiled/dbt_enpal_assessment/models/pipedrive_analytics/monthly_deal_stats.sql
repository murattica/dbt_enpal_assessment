select 
	date_trunc('month',date)::date as month,
	field,
	kpi_name,
	funnel_step,
	sum(deals_count) as deals_count
from "postgres"."test_pipedrive_analytics"."daily_deal_stats"
group by 
	month,
	field,
	kpi_name,
	funnel_step