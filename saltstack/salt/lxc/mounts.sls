mount vagrant inside containers:
  mount.mounted:
    - names:
      - /var/lib/lxc/redis/rootfs/vagrant
      - /var/lib/lxc/web/rootfs/vagrant
    - device: /vagrant
    - fstype: bindfs
    - mkmnt: True
    - opts:
      - relative
      - bind
      - rw
      - create=dir
      - nodev