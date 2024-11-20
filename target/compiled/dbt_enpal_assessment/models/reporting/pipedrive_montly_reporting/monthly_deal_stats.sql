



select 
	date_trunc('month',date)::date as month,
	field,
	kpi_name,
	funnel_step,
	sum(deals_count) as deals_count
from "postgres"."pipedrive_analytics"."daily_deal_stats"
where 1=1
	
	and date >= (date_trunc('month','2024-11-19'::date)::date  - interval '7' month)::date
	and date <= (date_trunc('month','2024-11-19'::date))::date
	
group by 
	month,
	field,
	kpi_name,
	funnel_step