containers_lxc:
  pkg.latest:
    - pkgs:
      - lxc-templates
      - lxc
      - dnsmasq
      - bridge-utils

  file.managed:
    - names:
      - /etc/dnsmasq.conf:
        - contents: |
            strict-order
            except-interface=lo
            bind-dynamic
            interface=virbr0
            dhcp-range=192.168.122.2,192.168.122.254
            dhcp-no-override
            dhcp-lease-max=253
            dhcp-hostsfile=/var/lib/dnsmasq/default.hostsfile
            addn-hosts=/var/lib/dnsmasq/default.addnhosts
      - /usr/share/lxc/config/centos.common.conf:
        - contents: |
            lxc.kmsg = 0
            lxc.devttydir = lxc
            lxc.tty = 4
            lxc.pts = 1024
            lxc.mount.auto = proc:mixed sys:ro
            lxc.hook.clone = /usr/share/lxc/hooks/clonehostname
            lxc.cap.drop = mac_admin mac_override setfcap
            lxc.cap.drop = sys_module sys_nice sys_pacct
            lxc.cap.drop = sys_rawio sys_time
            lxc.cgroup.devices.deny = a
            lxc.cgroup.devices.allow = c *:* m
            lxc.cgroup.devices.allow = b *:* m
            lxc.cgroup.devices.allow = c 1:3 rwm
            lxc.cgroup.devices.allow = c 1:5 rwm
            lxc.cgroup.devices.allow = c 1:7 rwm
            lxc.cgroup.devices.allow = c 5:0 rwm
            lxc.cgroup.devices.allow = c 1:8 rwm
            lxc.cgroup.devices.allow = c 1:9 rwm
            lxc.cgroup.devices.allow = c 136:* rwm
            lxc.cgroup.devices.allow = c 5:2 rwm
            lxc.seccomp = /usr/share/lxc/config/common.seccomp

  network.managed:
    - name: virbr0
    - enabled: True
    - type: bridge
    - ipaddr: 192.168.122.1
    - netmask: 255.255.255.0
    - bridge: virbr0
    - delay: 0

  iptables.insert:
    - names:
      - masquerade:
        - position: 1
        - table: nat 
        - chain: POSTROUTING
        - jump: MASQUERADE
        - out-interface: eth0
      - established:
        - position: 1
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - match: state
        - connstate: ESTABLISHED,RELATED
      - dhcp:
        - position: 2
        - table: filter
        - chain: INPUT
        - jump: ACCEPT
        - in-interface: virbr0
        - match: state
        - connstate: NEW

  service.running:
    - enable: True
    - names:
      - lxc
      - dnsmasq:
        - watch:
          - file: containers_lxc
      - network:
        - watch:
          - network: containers_lxc

  cloud.present:
    - names:
      - c7m1
      - c7m2
      - c7m3
      - c7m4
    - running: True
    - cloud_provider: mylxc
    - lxc_profile:
        template: centos
        options:
          release: 7
    - network_profile:
        eth0:
          link: virbr0

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

