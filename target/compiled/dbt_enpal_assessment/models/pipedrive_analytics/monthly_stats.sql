select 
	month,
	kpi_name,
	funnel_step,
    deals_count
from "postgres"."test_pipedrive_analytics"."monthly_deal_stats" 
where field = 'stage_id'

union all 

select 
	month,
	kpi_name,
	funnel_step,
    deals_count
from "postgres"."test_pipedrive_analytics"."monthly_activity_stats"
where kpi_name in ('Sales Call 1', 'Sales Call 2')