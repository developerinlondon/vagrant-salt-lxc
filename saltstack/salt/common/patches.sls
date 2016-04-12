# patch every week

update-packages:
  cmd.run:
    - name: yum update -y -d 0 -e 0 && touch /tmp/salt-install.yum-update-$(date '+%U')
    - creates: /tmp/yum-update-$(date '+%U')

upgrade-packages:
  cmd.run:
    - name: yum upgrade -y -d 0 -e 0 && touch /tmp/salt-install.yum-upgrade-$(date '+%U')
    - creates: /tmp/yum-update-$(date '+%U')
