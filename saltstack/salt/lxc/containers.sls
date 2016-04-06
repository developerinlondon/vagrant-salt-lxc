# the environment is needed as otherwise the lxc-ls used in lxc.present cannot find lxc.
# lxc_env:
#    environ.setenv:
#      - name: lxc environment variables
#      - value: 
#          LD_LIBRARY_PATH: $LD_LIBRARY_PATH:/opt/lxc/lib
#      - update_minion: True

# this was the old way before salt-cloud was working:
# web:
#   lxc.present:
#     - image: /vagrant/.lxc-tarballs/centosroot.tgz
#     - running: True
#     - require:
#       - environ: lxc_env
#       - cmd: centos_tarball
#       - service: lxc-net.service

# redis:
#   lxc.present:
#     - image: /vagrant/.lxc-tarballs/centosroot.tgz
#     - running: True
#     - require:
#       - environ: lxc_env
#       - cmd: centos_tarball
#       - service: lxc-net.service
#


# this is needed for line 120 as per https://github.com/saltstack/salt/pull/25231/files
# this can be taken out on a newer release of salt where they add this update.
# but without this the containers wont bootstrap with salt.
# hacked_lxc_py:
#   file.managed:
#     - name: /usr/lib/python2.7/site-packages/salt/modules/lxc.py
#     - source: salt://lib/lxc.py
#     - mode: 755
#     - user: root
#     - group: root

development-stack:
  cloud.present:
    - names:
      - redis
      - web
    - cloud_provider: mylxc_provider
    - lxc_profile:
        template: centos
    - network_profile:
        eth0:
          link: lxcbr0
    - minion:
       master: 10.0.2.15
       master_port: 4506
    - require:
   #   - file: hacked_lxc_py
  #    - environ: lxc_env
#       - cmd: centos_tarball
      - service: lxc-net.service
      - service: lxc-dhcp.service
      - service: iptables