/home/vagrant/.ssh/config:
  file.managed:
    - source: salt://ssh-config/files/ssh_config.conf
    - mode: 640
    - user: vagrant
    - group: vagrant
