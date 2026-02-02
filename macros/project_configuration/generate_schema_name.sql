{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set target_name = target.name | lower -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- elif target_name in ('dev','uat','main') -%}

        {{ custom_schema_name | trim }}

    {%- else -%}

        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}