Quickstart
----------

1. clone this repo.
2. run `vagrant up` (will take approx 15 mins to spin up a vagrant box with a web and a redis container inside it)
3. `vagrant ssh`
4. `sudo su`
5. run `lxc-ls` to see the containers that are running preconfigured.
6. run `lxc-attach -n web` to get inside the web container.

LXC Service
-----------

RUN `vagrant up` to get a basic vagrant box running centos 6.6 and has salt and lxc installed inside it.

inside vagrant run the following to reload stack:
`salt-call state.highstate`

checking event horizon:

`salt-run state.event pretty=true`


References:
-----------

http://ix.io/v1y

network config: https://www.flockport.com/enable-lxc-networking-in-debian-jessie-fedora-and-others/

storage https://www.flockport.com/lxc-advanced-guide/

stephanes guide: https://www.stgraber.org/2013/12/27/lxc-1-0-container-storage/

salt cloud: http://makina-corpus.com/blog/metier/2014/salt-cloud-can-now-spawn-lxc-containers-or-how-saltstack-made-lxc-containers-managment-easy

salt beacon - https://docs.saltstack.com/en/latest/ref/beacons/all/index.html#all-salt-beacons
salt reactor - https://docs.saltstack.com/en/latest/topics/reactor/

fix to implement:
-----------------
https://github.com/saltstack/salt/commit/559eb7da520953ef54adf6b779fe959e39d94d92
