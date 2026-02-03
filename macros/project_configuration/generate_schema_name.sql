{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set target_name = target.name | lower -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- elif target_name in ('dev','uat','main') -%}

        {{ custom_schema_name | trim }}

    {%- elif target_name in ('dev_ci_cd','uat_ci_cd','main_ci_cd') -%}

        {{ (custom_schema_name | trim) ~ '_CI_CD' }}

    {%- else -%}

        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}
