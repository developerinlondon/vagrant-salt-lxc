# patch every week

update-packages:
  cmd.run:
    - name: yum update -y -d 0 -e 0 && touch /tmp/yum-update-$(date '+%U')
    - unless: test -f /tmp/yum-update-$(date '+%U')

upgrade-packages:
  cmd.run:
    - name: yum upgrade -y -d 0 -e 0 && touch /tmp/yum-upgrade-$(date '+%U')
    - unless: test -f /tmp/yum-update-$(date '+%U')
