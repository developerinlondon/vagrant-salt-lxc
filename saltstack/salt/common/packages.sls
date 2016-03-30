common_packages:
  pkg.installed:
    - names:
      - htop
      - strace
      - lxc
      - vim-enhanced

/etc/vimrc:
  file.managed:
    - source: salt://common/vimrc
    - mode: 644
    - user: root
    - group: root

lxc.container_profile:
  - centos:
    - template: centos
    - backing: lvm
    - vgname: vg1
    - lvname: lxclv
    - size: 10G