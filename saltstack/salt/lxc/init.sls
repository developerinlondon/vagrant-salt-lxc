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

/vagrant/.lxc-tarballs/centosroot.tgz:
  file.managed:
    - source: https://s3-eu-west-1.amazonaws.com/lxc-tarballs/centosroot.tgz
    - source_hash: md5=eabb7b95aff35810eba7ae9b3d93053f
    - mode: 600
    - makedirs: True

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

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

web:
  lxc.present:
    - image: /vagrant/.lxc-tarballs/centosroot.tgz
    - running: True
    - require:
      - file: /vagrant/.lxc-tarballs/centosroot.tgz
      - service: lxc-net.service

redis:
  lxc.present:
    - image: /vagrant/.lxc-tarballs/centosroot.tgz
    - running: True
    - require:
      - file: /vagrant/.lxc-tarballs/centosroot.tgz
      - service: lxc-net.service

