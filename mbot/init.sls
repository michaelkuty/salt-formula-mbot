{%- if pillar.mbot is defined %}
include:
{%- if pillar.mbot.server is defined %}
- mbot.server
{%- endif %}
{%- endif %}
