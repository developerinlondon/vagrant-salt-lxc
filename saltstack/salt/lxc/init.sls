epel:
  pkg.installed:
    - sources:
      - epel-release: /vagrant/saltstack/salt/lib/epel-release-7-5.noarch.rpm

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

/usr/lib/python2.7/site-packages/salt/templates/lxc/salt_tarball:
  file.managed:
    - source: salt://lib/salt_tarball
    - mode: 755
    - user: root
    - group: root

lxc-net.service:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/lxc-net.service

lxc-dhcp.service:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/lxc-dhcp.service

iptables:
  service.running:
    - enable: True
    - require:
      - file: /etc/sysconfig/iptables

# lxc.create:
#   container1:
#     - profile: centos
#     - network_profile: centos 
#     - nic_opts: '{eth0: {ipv4: 10.0.3.0/24, gateway: 10.0.3.1}}'

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

# lxc.network_profile:
#   lxc-default:
#     eth0:
#       link: lxcbr0
#       type: veth
#       flags: up

web2:
  lxc.present:
    - image: /vagrant/.snapshots/centosroot.tgz
    - running: True
    - require:
      - file: /vagrant/.lxc-tarballs/centosroot.tgz
      - service: lxc-net.service

# redis:
#   lxc.present:
#     - template: download
#     - options:
#       dist: centos
#       release: 7
#       arch: amd64

