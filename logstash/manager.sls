logstash:
  pipelines:
    manager:
      config:
        - so/0001_input_sublime.conf
        - so/0009_input_beats.conf      
        - so/0010_input_hhbeats.conf
        - so/0011_input_endgame.conf
        - so/9999_output_redis.conf.jinja
        
