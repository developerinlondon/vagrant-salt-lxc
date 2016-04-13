# the environment is needed as otherwise the lxc-ls used in lxc.present cannot find lxc.
lxc_env:
  environ.setenv:
    - name: lxc environment variables
    - value: 
        LD_LIBRARY_PATH: $LD_LIBRARY_PATH:/opt/lxc/lib
    - update_minion: True

development-stack:
  cloud.present:
    - names: {{ pillar['containers'] }}
    - cloud_provider: mylxc_provider
    - lxc_profile:
        template: centos

    - network_profile:
        eth0:
          link: lxcbr0
    - minion:
       master: 10.0.2.15
       master_port: 4506
       hash_type: sha256
       startup_states: 'highstate'
    - require:
      - file: patched_lxc_py
      - environ: lxc_env
#       - cmd: centos_tarball
      - service: lxc-net.service
      - service: lxc-dhcp.service
      - service: iptables
#     - service: salt-master