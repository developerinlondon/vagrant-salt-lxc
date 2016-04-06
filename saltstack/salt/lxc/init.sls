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

tarball_folder:
  file.directory:
    - name: /vagrant/.lxc-tarballs
    - mode: 755
    - makedirs: True

CentosTarball:
  cmd.run:
    - name: wget https://s3-eu-west-1.amazonaws.com/lxc-tarballs/centosroot.tgz -q -O /vagrant/.lxc-tarballs/centosroot.tgz
    - creates: /vagrant/.lxc-tarballs/centosroot.tgz
    - stateful: True
    - require:
      - file: tarball_folder

/etc/salt/cloud.profiles.d/lxc.conf:
  file.managed:
    - source: salt://lxc/files/lxc_profile.conf
    - mode: 644
    - user: root
    - group: root

/etc/salt/cloud.providers.d/lxc.conf:
  file.managed:
    - source: salt://lxc/files/lxc_provider.conf
    - mode: 644
    - user: root
    - group: root

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

# lxc.bootstrap:
#   web:
#     install: True

# myfancylxc:
#   cloud.profile:
#     - profile: mylxc_profile
#     - minion:
#       # where will be your master located on the lxc point of view
#       - master: 10.0.3.1
#       - master_port: 4506

# c7:
#   cloud.present:
#     - running: True
#     - cloud_provider: mylxc_provider
#     - lxc_profile:
#  #     name: mylxc
#       template: /usr/lib/python2.7/site-packages/salt/templates/lxc/salt_tarball  -- -p /vagrant/.lxc-tarballs/centosroot.tgz

# cloud.present:
#   - names:
#     - c7m1
#     - c7m2
#     - c7m3
#     - c7m4
#   - running: True
#   - cloud_provider: mylxc
#   - lxc_profile:
#       template: centos
#       options:
#         release: 7
#   - network_profile:
#       eth0:
#         link: virbr0