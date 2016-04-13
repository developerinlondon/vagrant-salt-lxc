mount /vagrant inside containers:
  mount.mounted:
    - names:
      - /var/lib/lxc/container_redis/rootfs/vagrant
      - /var/lib/lxc/container_web/rootfs/vagrant
    - device: /vagrant
    - fstype: bindfs
    - mkmnt: True
    - persist: False
    - opts:
      - bind
