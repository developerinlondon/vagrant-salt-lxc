LXC Service
-----------

RUN `vagrant up` to get a basic vagrant box running centos 6.6 and has salt and lxc installed inside it.

inside vagrant run the following to reload stack:
`salt-call --local state.apply`

References:
-----------

http://ix.io/v1y

network config: https://www.flockport.com/enable-lxc-networking-in-debian-jessie-fedora-and-others/

storage https://www.flockport.com/lxc-advanced-guide/

stephanes guide: https://www.stgraber.org/2013/12/27/lxc-1-0-container-storage/

lxc loadbalancing https://www.flockport.com/load-balancing-and-failover-with-lxc-containers/
lxc networking guide https://www.flockport.com/lxc-networking-guide/
