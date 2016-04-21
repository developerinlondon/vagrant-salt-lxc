/etc/systemd/system/lxc-net.service:
  file.managed:
    - source: salt://lxc/files/lxc-net.service
    - mode: 644
    - user: root
    - group: root

/etc/systemd/system/lxc-dhcp.service:
  file.managed:
    - source: salt://lxc/files/lxc-dhcp.service
    - mode: 644
    - user: root
    - group: root

/etc/systemd/system/redshift-tunnel.service:
  file.managed:
    - source: salt://lxc/files/redshift-tunnel.service
    - mode: 644
    - user: root
    - group: root

/etc/hosts:
  file.managed:
    - source: salt://lxc/files/etc_hosts
    - mode: 644

lxc-net.service:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/systemd/system/lxc-net.service
    - require:
      - file: /etc/systemd/system/lxc-net.service

lxc-dhcp.service:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/systemd/system/lxc-dhcp.service
      - file: /etc/hosts
    - require:
      - file: /etc/systemd/system/lxc-dhcp.service
      - file: /etc/hosts


redshift-tunnel.service:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/systemd/system/redshift-tunnel.service
    - require:
      - file: /etc/systemd/system/redshift-tunnel.service
      - file: vagrant_ssh_conf