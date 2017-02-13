{%- from "mbot/map.jinja" import server with context %}
{%- if server.enabled %}

mbot_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

mbot_user:
  user.present:
  - name: mbot
  - shell: /bin/bash
  - system: true
  - home: {{ server.dir.home }}

mbot_dirs:
  file.directory:
  - names:
    - /srv/mbot
    - /srv/mbot/app
    - /var/log/mbot
    - /srv/mbot/flags
  - makedirs: true
  - group: mbot
  - user: mbot
  - require:
    - user: mbot

{{ server.dir.home }}:
  virtualenv.manage:
  - requirements: salt://mbot/files/requirements.txt
  - python: /usr/bin/python3
  - user: mbot
  - require:
    - pkg: mbot_packages

mbot_installation:
  pip.installed:
  {%- if server.source.get('engine', 'git') == 'git' %}
  - editable: "git+{{ server.source.address }}#egg=mbot"
  {%- elif server.source.engine == 'pip' %}
  - name: mbot {%- if server.version is defined %}=={{ server.version }}{% endif %}
  {%- endif %}
  - name: mbot
  - bin_env: /srv/mbot
  - exists_action: w
  - require:
    - virtualenv: /srv/mbot

{% for plugin_name, plugin in server.get('plugin', {}).iteritems() %}
{% if not plugin.get('site', false) %}
mbot_{{ plugin_name }}_req:
  pip.installed:
  {%- if 'source' in plugin and plugin.source.get('engine', 'git') == 'git' %}
  - editable: {{ plugin.source.address }}
  {%- else %}
  - name: {{ plugin_name }} {%- if plugin.version is defined %}=={{ plugin.version }}{% endif %}
  {%- endif %}
  - bin_env: /srv/mbot
  - exists_action: w
  - require:
    - virtualenv: /srv/mbot
{% endif %}
{% endfor %}

/var/log/mbot/access.log:
  file.managed:
  - mode: 666
  - user: mbot
  - group: mbot
  - require:
    - file: mbot_dirs

/var/log/mbot/error.log:
  file.managed:
  - mode: 666
  - user: mbot
  - group: mbot
  - require:
    - file: mbot_dirs

{{ server.dir.home }}/mbot.conf:
  file.managed:
  - source: salt://mbot/files/mbot.conf
  - template: jinja
  - user: mbot
  - group: mbot
  - mode: 644
  - require:
    - file: mbot_dirs

{%- endif %}
