



select 
	date,
	field,
	kpi_name,
		    case 
	        when kpi_name = 'Lead Generation' then 'Step 1'
	        when kpi_name = 'Qualified Lead' then 'Step 2'
	        when kpi_name = 'Needs Assessment' then 'Step 3'
	        when kpi_name = 'Proposal/Quote Preparation' then 'Step 4'
	        when kpi_name = 'Negotiation' then 'Step 5'
	        when kpi_name = 'Closing' then 'Step 6'
	        when kpi_name = 'Implementation/Onboarding' then 'Step 7'
	        when kpi_name = 'Follow-up/Customer Success' then 'Step 8'
	        when kpi_name = 'Renewal/Expansion' then 'Step 9'
	    end as funnel_step,
	count(distinct deal_id) as deals_count
from "postgres"."pipedrive_analytics_staging"."deals_staging" 
where 1=1
	
	and date >= '2024-11-19'::date - 7
	and date <= '2024-11-19'::date 
	
group by 
	date,
	field,
	kpi_name