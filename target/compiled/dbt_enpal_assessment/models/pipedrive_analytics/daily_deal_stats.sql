with deals_join as 
(
	select 
		t1.deal_id,
		t1.change_time::date as date,
		changed_field_key as field,
		case when changed_field_key = 'stage_id' then (select value->>'label' from jsonb_array_elements(field_value_options::jsonb) as value where value->>'id' = new_value) 
			 when changed_field_key = 'lost_reason' then (select value->>'label' from jsonb_array_elements(field_value_options::jsonb) as value where value->>'id' = new_value)
			 when changed_field_key = 'user_id' then 'User added'
			 when changed_field_key = 'add_time' then 'Deal created'
			 else new_value
		end as stage_label
	from "postgres"."public"."deal_changes" t1
	left join "postgres"."public"."fields" t2
	on t1.changed_field_key = t2.field_key
),

deals_base as 
(
	select
	    t1.deal_id,
	    date,
		field,
	    stage_label as kpi_name
	from deals_join t1
)

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
from deals_base
group by 
	date,
	field,
	kpi_name