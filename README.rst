
====
mbot
====

Service mbot description

Sample pillars
==============

Single mbot service

.. code-block:: yaml

    mbot:
      server:
        enabled: true
        workers: 10
        source:
          engine: git
          address: https://github.com/michaelkuty/mbot.git
        backend:
          mqtt:
            engine: mbot.backends.mqtt.MQTT
            host: localhost
            subscribe:
              - "$SYS/#"
            middlewares:
              - mbot.contrib.debug.Debug
          slack:
            token: xoxb-4564651231-asdadas4654646
            engine: mbot.backends.slack.Slack
            middlewares:
              - mbot.contrib.system.Config
              - mbot.contrib.history.history
              - mbot.contrib.debug.Debug
              - mbot.contrib.bash.Bash
              - mbot.contrib.console.MBotConsole
              - mbot.contrib.python.Python
              - mbot.contrib.joker.Joker
              - mbot.contrib.hackernews.HackerNews
              - mbot.contrib.scheduler.Scheduler
              - mbot.contrib.salt.Salt
              - mbot.contrib.connections.Connections
              - mbot.contrib.dialogs.Dialogs
              - mbot.contrib.airflow.AirflowTrigger
              - mbot.contrib.sql.SQL
              - mbot.contrib.help.Help
              - mbot.contrib.jinja2.Template
              - mbot.contrib.yfinance.YahooFinance
        storage:
          engine: local
          encrypt: True
          fernet_token: 9H0gcBFw9zG4e4TqmeLtyIhLRnt9hUhV6251o8aDAkc=
        logging:
          level: DEBUG
        plugin:
          name:
            source:
              engine: git
              address: git@url
          pluginname:

Read more
=========

* https://github.com/michaelkuty/mbot
