base:
  'vagranthost':
    - common
    - salt
    - lxc
    - dashboard
  'redis':
    - common
    - container_redis
  'web':
    - common
    - container_web