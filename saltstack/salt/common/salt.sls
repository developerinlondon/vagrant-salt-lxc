salt_packages:
  pkg.installed:
    - names:
      - salt-minion
      - salt-master
      - salt-cloud
      - salt-ssh
      - salt-syndic

salt-master-service:
  service.running:
    - name: salt-master
    - enable: True
    - reload: True
    - watch:
      - pkg: salt-master
    - require:
      - pkg: salt-master

salt-minion-service:
  service.running:
    - name: salt-minion
    - enable: True
    - reload: True
    - watch:
      - pkg: salt-minion
    - require:
      - pkg: salt-minion


Accept VM Minion Key:
  cmd.run:
    - name: salt-key -a 'vm.ad.here.com' -y
    - creates: /etc/salt/pki/master/minions/vm.ad.here.com
    - watch:
      - service: salt-minion
      - service: salt-master
    - require:
      - service: salt-minion
      - service: salt-master