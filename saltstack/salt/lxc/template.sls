
salt_tarball:
  file.managed:
    - name: /usr/lib/python2.7/site-packages/salt/templates/lxc/salt_tarball
    - source: salt://lib/salt_tarball
    - mode: 755
    - user: root
    - group: root
