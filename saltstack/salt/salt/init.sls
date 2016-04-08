salt_packages:
  pkg.installed:
    - names:
      # - salt-minion
      # - salt-master
      - salt-cloud
      - salt-ssh
      - salt-syndic

# /etc/salt/master:
#   file.managed:
#     - source: /vagrant/saltstack/etc/salt/master
# #     - mode: 640
# #     - user: root
# #     - group: root

# /etc/salt/minion:
#   file.managed:
#     - source: /vagrant/saltstack/etc/salt/minion
# #     - mode: 640
# #     - user: root
# #     - group: root

# /etc/salt/minion.d:
#   file.recurse:
#     - source: salt://salt/files/minion.d

# salt-master-service:
#   service.running:
#     - name: salt-master
#     - enable: True
#     - reload: True
#     - watch:
#       - pkg: salt-master
#       - file: /etc/salt/master
#    #   - cloud: development-stack
#     - require:
#       - pkg: salt-master
#   #    - cloud: development-stack

# salt-minion-service:
#   service.running:
#     - name: salt-minion
#     - enable: True
#     - reload: True
#     - watch:
#       - pkg: salt-minion
#       - file: /etc/salt/minion
#       - file: /etc/salt/minion.d
#     - require:
#       - pkg: salt-minion
#       - service: salt-master

# # first run (run every hour anyways)
# update-minions:
#   cmd.run:
#     - name: salt '*' state.apply && touch /tmp/update-minions-$(date '+%H')
#     - creates: /tmp/salt/update-minions-$(date '+%H')
#   require:
#     - service: salt-master
#     - service: salt-minion
#     - cloud: development-stack

# include:
#   - salt.cloud
#  - salt.watchers