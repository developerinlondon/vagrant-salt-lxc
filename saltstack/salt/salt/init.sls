salt_packages:
  pkg.installed:
    - names:
      - salt-minion
      - salt-master
      - salt-cloud
      - salt-ssh
      - salt-syndic

/etc/salt/master:
  file.managed:
    - source: salt://salt/files/master.yaml
    - mode: 640
    - user: root
    - group: root

salt-master-service:
  service.running:
    - name: salt-master
    - enable: True
    - reload: True
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master
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
