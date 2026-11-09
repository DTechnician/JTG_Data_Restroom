{% macro bg_reset() %}
  {% if var('blue_green', false) %}
    CALL DB_JTG_ADMIN.ORCHESTRATION.SP_RESET_LOAD_DB();
  {% endif %}
{% endmacro %}

{% macro bg_swap(results) %}
  {% if var('blue_green', false) and execute %}
    {% set failed = results | selectattr('status', 'in', ['error', 'fail', 'runtime error']) | list %}
    {% if failed | length == 0 %}
      CALL DB_JTG_ADMIN.ORCHESTRATION.SP_SWAP_LOAD_TO_LIVE();
    {% else %}
      {{ log('blue_green: ' ~ failed | length ~ ' failures, swap skipped', info=True) }}
    {% endif %}
  {% endif %}
{% endmacro %}