python-pip:
  pkg.installed

upgrade-pip:
  cmd.run:
    - name: pip install --upgrade pip && touch /tmp/salt-install.pip-upgraded-$(date '+%U')
    - require: 
      - pkg: python-pip
    - creates: /tmp/salt-install.pip-upgraded-$(date '+%U')

virtualenvwrapper:
  pip.installed:
    - require:
      - cmd: upgrade-pip