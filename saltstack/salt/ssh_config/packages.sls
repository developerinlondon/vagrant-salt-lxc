ssh_packages:
  pkg.installed:
    - names:
      - autossh
      - supervisor

# sudoers:
#   file.managed:
#     - name: /etc/sudoers
#     - source: salt://ssh_config/files/sudoers
#     - makedirs: True
