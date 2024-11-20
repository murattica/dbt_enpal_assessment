{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='date',
        alias='daily_deal_stats',
        on_schema_change='append_new_columns',
        full_refresh= false
    )
}}

{% set source = source_dt(var('source_dt')) %}

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
from {{ ref('deals_staging') }} 
where 1=1
	{% if is_incremental() %}
	and date >= '{{ source }}'::date - {{ var('backfill_period') }}
	and date <= '{{ source }}'::date 
	{% else %}
	and date > date_trunc('month', current_date) - interval '{{ var('months') }} month'  
	{% endif %}
group by 
	date,
	field,
	kpi_name