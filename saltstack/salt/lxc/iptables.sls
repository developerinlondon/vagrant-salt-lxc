/etc/sysconfig/iptables:
  file.managed:
    - source: salt://lxc/files/iptables
    - mode: 600
    - user: root
    - group: root

# this must be disabled from centos7 to use iptables service
firewalld:
  service:
    - dead
    - enable: False
    - reload: False
    - require_in:
      service: iptables

iptables:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/sysconfig/iptables
    - require:
      - file: /etc/sysconfig/iptables
     # - service: firewalld