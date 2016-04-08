# salt-cloud:
#   pkg:
#     - installed
#     - require:
#       - pkg: salt-master

/etc/salt/cloud.profiles.d/lxc.conf:
  file.managed:
    - source: salt://salt/files/salt_cloud/lxc_profile.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: salt-cloud

/etc/salt/cloud.providers.d/lxc.conf:
  file.managed:
    - source: salt://salt/files/salt_cloud/lxc_provider.conf
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: salt-cloud