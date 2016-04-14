/etc/profile.d/salt.sh:
  file.managed:
    - source: salt://salt/files/profile.salt.sh
    - mode: 644
