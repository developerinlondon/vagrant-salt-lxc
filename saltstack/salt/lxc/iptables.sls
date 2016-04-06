/etc/sysconfig/iptables:
  file.managed:
    - source: salt://lxc/files/iptables
    - mode: 600
    - user: root
    - group: root

iptables:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/sysconfig/iptables