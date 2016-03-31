epel:
  pkg.installed:
    - sources:
      - epel-release: /vagrant/saltstack/lib/epel-release-7-5.noarch.rpm

lxc:
  pkg.latest:
    - pkgs:
      - lxc
      - lxc-templates
      - dnsmasq
      - bridge-utils
      - iptables-services

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

  # /etc/sysctl.conf:
  #   file.managed:
  #     - source: salt://lxc/files/sysctl.conf
  #     - mode: 644
  #     - user: root
  #     - group: root

/etc/lxc/default.conf:
  file.managed:
    - source: salt://lxc/files/default.conf
    - mode: 644
    - user: root
    - group: root

/etc/sysconfig/iptables:
  file.managed:
    - source: salt://lxc/files/iptables
    - mode: 600
    - user: root
    - group: root

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1


  service.running:
    - enable: True
    - names:
      - lxc-net.service
      - lxc-dhcp.service
      - iptables