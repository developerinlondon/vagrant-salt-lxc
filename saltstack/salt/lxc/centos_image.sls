tarball_folder:
  file.directory:
    - name: /vagrant/.lxc-tarballs
    - mode: 755
    - makedirs: True

centos_tarball:
  cmd.run:
    - name: wget https://s3-eu-west-1.amazonaws.com/lxc-tarballs/centosroot.tgz -q -O /vagrant/.lxc-tarballs/centosroot.tgz
    - creates: /vagrant/.lxc-tarballs/centosroot.tgz
    - stateful: True
    - require:
      - file: tarball_folder
