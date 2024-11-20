{% macro get_ref_date() %}
    {{ return(run_started_at.strftime('%Y-%m-%d')) }}
{% endmacro %}