base:
  '*':
    - common
  'vagranthost':
    - minions.vagranthost
  'container_redis':
    - minions.containers.redis
  'container_web':
    - minions.containers.web
