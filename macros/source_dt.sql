{% macro source_dt(arg) %}
    {% if arg == '' %}
        {{ return(get_ref_date()) }}
    {% else %}
        {{ return(arg) }}
    {% endif %}
{% endmacro %}