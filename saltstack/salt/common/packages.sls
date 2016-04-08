common_packages:
  pkg.installed:
    - names:
      - htop
      - strace
      - vim-enhanced
      - traceroute
      - awscli
      - strace
      - wget
      - gdb
      - nmap-ncat
#      - ufw

development-tools:
  pkg.group_installed:
    - name: 'Development Tools'

/etc/vimrc:
  file.managed:
    - source: salt://common/vimrc
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: vim-enhanced

epel:
  pkg.installed:
    - sources:
      - epel-release: /vagrant/saltstack/salt/lib/epel-release-7-5.noarch.rpm

