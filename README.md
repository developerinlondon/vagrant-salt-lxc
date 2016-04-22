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


Problem regarding tunnels:
--------------------------

It generally requires agent forwarding to work from host, to vagrant host (vagrant user) to root user in the vagrant host. However in order for that to work we need the SSH_AUTH_SOCK variable to be passed on. This is only done by setting it up on /etc/sudoers. The time saltstack runs initially this is not done, so we will end up with the tunnel not being properly established the first time around. This would need to be triggered later on in order for this to work. The code can be found in ssh_config/tunnels.sls, and we would need to clear the temporary file /tmp/redshift_tunnel* and remove the autossh process in order to do this properly.

we tried using the fix suggested here https://github.com/mitchellh/vagrant/issues/1303


References:
-----------

http://ix.io/v1y

network config: https://www.flockport.com/enable-lxc-networking-in-debian-jessie-fedora-and-others/

storage https://www.flockport.com/lxc-advanced-guide/

stephanes guide: https://www.stgraber.org/2013/12/27/lxc-1-0-container-storage/

salt cloud: http://makina-corpus.com/blog/metier/2014/salt-cloud-can-now-spawn-lxc-containers-or-how-saltstack-made-lxc-containers-managment-easy

salt beacon - https://docs.saltstack.com/en/latest/ref/beacons/all/index.html#all-salt-beacons
salt reactor - https://docs.saltstack.com/en/latest/topics/reactor/

saltpad - for UI

salt-formula - for compartmentalizing salt states.


fix to implement:
-----------------
https://github.com/saltstack/salt/commit/559eb7da520953ef54adf6b779fe959e39d94d92

example vagrant tunnel:
-----------------------
 ssh vagrant@127.0.0.1 -p 2200 -o Compression=yes -o DSAAuthentication=yes -o LogLevel=FATAL -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -i /Users/meex_syen/code/here/lxc/.vagrant/machines/default/virtualbox/private_key -L 8080:localhost:81 -N

saltpad:
--------
formula - https://github.com/tinyclues/saltpad/tree/saltpad_v2/vagrant/salt/roots/salt

