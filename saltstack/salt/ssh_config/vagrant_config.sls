vagrant_ssh_conf:
  file.managed:
    - name: /home/vagrant/.ssh/config
    - source: salt://ssh_config/files/ssh_config.conf
    - mode: 640
    - user: vagrant
    - group: vagrant
    - require:
      - pkg: autossh
