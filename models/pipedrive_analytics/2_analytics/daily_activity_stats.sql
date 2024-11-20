{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='date',
        alias='daily_activity_stats',
        on_schema_change='append_new_columns',
        full_refresh= false
    )
}}

{% set source = source_dt(var('source_dt')) %}

select 
	due_date as date,
	kpi_name,
	funnel_step,
	count(distinct case when done = true then deal_id end) as deals_count
from {{ ref('activity_staging') }}  
where 1=1
	{% if is_incremental() %}
	and due_date >= '{{ source }}'::date - {{ var('backfill_period') }}
	{% else %}
	and due_date > date_trunc('month', current_date) - interval '{{ var('months') }} month'  
	{% endif %}
group by 
	date,
	kpi_name,
	funnel_step


