
lxc-requisites:
  pkg.latest:
    - pkgs:
      - libcap-devel
      - libcgroup
      - dnsmasq
      - bridge-utils
      - iptables-services