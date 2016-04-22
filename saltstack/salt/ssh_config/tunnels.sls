redshift_tunnel:
  cmd.run:
    - name: autossh -N redshift-dev -M 10000 && touch /tmp/socket-redshift-$(date +%W)
    - user: vagrant
    - unless:  test -f /tmp/socket-redshift-$(date +%W)
    - require:
      - pkg: autossh
      - file: vagrant_ssh_conf
      - file: sudoers