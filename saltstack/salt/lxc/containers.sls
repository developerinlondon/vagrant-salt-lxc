lxc_env:
   environ.setenv:
     - name: lxc environment variables
     - value: 
         LD_LIBRARY_PATH: $LD_LIBRARY_PATH:/opt/lxc/lib
     - update_minion: True
web:
  lxc.present:
    - image: /vagrant/.lxc-tarballs/centosroot.tgz
    - running: True
    - require:
      - environ: lxc_env
      - cmd: centos_tarball
      - service: lxc-net.service

redis:
  lxc.present:
    - image: /vagrant/.lxc-tarballs/centosroot.tgz
    - running: True
    - require:
      - environ: lxc_env
      - cmd: centos_tarball
      - environ: lxc_env
      - service: lxc-net.service

# my-lxc:
#   # the provider to use
#   provider: mylxc_provider
#   lxc_profile:
#       template: centos
#   minion:
#      master: 10.0.2.15
#      master_port: 4506