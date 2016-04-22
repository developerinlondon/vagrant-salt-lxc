supervisor_log:
  file.managed:
    - name: /var/log/supervisord.log
    - user: vagrant
    - group: vagrant 

supervisor_tunnels:
  file.managed:
    - name: /etc/supervisord.d/tunnels.ini
    - source: salt://ssh_config/files/tunnels.ini
    - mode: 640
    - makedirs: True
    - require:
      - file: vagrant_ssh_conf
      - pkg: supervisor

supervisor_config:
  file.managed:
    - name: /etc/supervisord.conf
    - source: salt://ssh_config/files/supervisord.conf
    - mode: 640
    - makedirs: True
    - require:
      - file: vagrant_ssh_conf
      - pkg: supervisor
      - file: sudoers

supervisord:
  service.running:
    - enable: True
    - watch:
      - file: supervisor_config
    - require:
      - file: supervisor_config
