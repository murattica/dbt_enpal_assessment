select 
    t1.deal_id,
    t1.change_time::date as date,
    changed_field_key as field,
    case when changed_field_key = 'stage_id' then (select value->>'label' from jsonb_array_elements(field_value_options::jsonb) as value where value->>'id' = new_value) 
            when changed_field_key = 'lost_reason' then (select value->>'label' from jsonb_array_elements(field_value_options::jsonb) as value where value->>'id' = new_value)
            when changed_field_key = 'user_id' then 'User added'
            when changed_field_key = 'add_time' then 'Deal created'
            else new_value
    end as kpi_name
from "postgres"."public"."deal_changes" t1
left join "postgres"."public"."fields" t2
on t1.changed_field_key = t2.field_key