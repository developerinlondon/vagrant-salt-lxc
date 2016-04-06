base:
  'vagranthost':
    - common
    - salt
    - lxc

  'redis':
    - container_redis
  'web':
    - container_web