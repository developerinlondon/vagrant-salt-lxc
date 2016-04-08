
install-lxc:
  cmd.run:
    - name: |
        cd /tmp
        wget --quiet -c http://linuxcontainers.org/downloads/lxc-1.1.5.tar.gz
        tar xzf lxc-1.1.5.tar.gz
        cd lxc-1.1.5
        ./configure --prefix=/opt/lxc --bindir=/usr/bin --localstatedir=/var --sbindir=/usr/sbin --sysconfdir=/etc > /var/log/configure.lxc-install
        make  > /var/log/make.lxc-install
        make install > /var/log/make-install.lxc-install
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 300
    - creates: /usr/bin/lxc-info

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
