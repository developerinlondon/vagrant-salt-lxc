salt-services:
  service.running:
    - names:
      - salt-api
    - enable: True
    - reload: True
