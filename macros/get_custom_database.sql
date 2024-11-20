{% macro generate_database_name(custom_database_name, node) -%}

    {%- set default_database = target.database -%}
    {%- if target.name == 'production' and custom_database_name is not none -%}

        {{ custom_database_name | trim }}

    {%- else -%}

        {{ default_database }}

    {%- endif -%}

{%- endmacro %}
