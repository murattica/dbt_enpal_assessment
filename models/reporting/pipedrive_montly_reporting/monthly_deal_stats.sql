{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        unique_key='month',
        alias='monthly_deal_stats',
        on_schema_change='append_new_columns',
        full_refresh= false
    )
}}

{% set source = source_dt(var('source_dt')) %}

select 
	date_trunc('month',date)::date as month,
	field,
	kpi_name,
	funnel_step,
	sum(deals_count) as deals_count
from {{ ref('daily_deal_stats') }}
where 1=1
	{% if is_incremental() %}
	and date >= (date_trunc('month','{{ source }}'::date)::date  - interval '{{ var('backfill_period') }}' month)::date
	and date <= (date_trunc('month','{{ source }}'::date))::date
	{% else %}
	and date >= (date_trunc('month','{{ source }}'::date)::date - interval '{{ var('months') }}' month)::date
	{% endif %}
group by 
	month,
	field,
	kpi_name,
	funnel_step