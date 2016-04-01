common_packages:
  pkg.installed:
    - names:
      - htop
      - strace
      - vim-enhanced
      - traceroute

/etc/vimrc:
  file.managed:
    - source: salt://common/vimrc
    - mode: 644
    - user: root
    - group: root
