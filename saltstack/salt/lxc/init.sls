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

SaltTarball:
  file.managed:
    - name: /usr/lib/python2.7/site-packages/salt/templates/lxc/salt_tarball
    - source: salt://lib/salt_tarball
    - mode: 755
    - user: root
    - group: root

CentosTarball:
  cmd.run:
    - name: wget https://s3-eu-west-1.amazonaws.com/lxc-tarballs/centosroot.tgz -q --progress=bar:force:noscroll -O /vagrant/.lxc-tarballs/centosroot.tgz
    - creates: /vagrant/.lxc-tarballs/centosroot.tgz
    - stateful: True

lxc-net.service:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/systemd/system/lxc-net.service


lxc-dhcp.service:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/systemd/system/lxc-dhcp.service

iptables:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/sysconfig/iptables

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

web:
  lxc.present:
    - image: /vagrant/.lxc-tarballs/centosroot.tgz
    - running: True
    - require:
      - cmd: CentosTarball
      - service: lxc-net.service

redis:
  lxc.present:
    - image: /vagrant/.lxc-tarballs/centosroot.tgz
    - running: True
    - require:
      - cmd: CentosTarball
      - service: lxc-net.service

