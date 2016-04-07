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
    - require:
      - file: /etc/systemd/system/lxc-dhcp.service
