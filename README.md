LXC Service
-----------

RUN `vagrant up` to get a basic vagrant box running centos 6.6 and has salt and lxc installed inside it.

inside vagrant run the following to reload stack:
`salt-call --local state.apply`

References:
-----------

http://ix.io/v1y