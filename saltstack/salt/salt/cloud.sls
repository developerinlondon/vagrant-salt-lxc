/etc/salt/cloud.profiles.d/lxc.conf:
  file.managed:
    - source: salt://lxc/files/lxc_profile.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: salt-cloud

/etc/salt/cloud.providers.d/lxc.conf:
  file.managed:
    - source: salt://lxc/files/lxc_provider.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: salt-cloud