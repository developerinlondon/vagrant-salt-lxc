mount /vagrant inside containers:
  mount.mounted:
    - names:
      {% for container in pillar.get('containers', []) %}
      - /var/lib/lxc/{{ container }}/rootfs/vagrant
      {% endfor %}
    - device: /vagrant
    - fstype: bindfs
    - mkmnt: True
    - persist: False
    - opts:
      - bind
