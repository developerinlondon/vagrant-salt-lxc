
install-lxc:
  cmd.run:
    - name: |
        cd /tmp
        wget -c http://linuxcontainers.org/downloads/lxc-1.1.5.tar.gz
        tar vxzf lxc-1.1.5.tar.gz
        cd lxc-1.1.5
        ./configure --prefix=/opt/lxc --bindir=/usr/local/bin --sbindir=/usr/sbin --sysconfdir=/etc
        make
        make install
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 300
    - unless: test -x /opt/lxc/bin/lxc-info

/etc/profile.d/lxc.sh:
  file.managed:
    - source: salt://lxc/files/profile.lxc.sh
    - mode: 644

/etc/lxc/default.conf:
  file.managed:
    - source: salt://lxc/files/default.conf
    - mode: 644
    - user: root
    - group: root

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1
