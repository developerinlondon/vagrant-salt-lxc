base:
  'vagranthost':
    - common
    - salt
    - lxc

  'redis':
    - common
    - container_redis
  'web':
    - common
    - container_web