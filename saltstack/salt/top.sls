base:
  '*':
    - common
  'vagranthost':
    - salt
    - lxc
  'container_redis':
    - container_redis
  'container_web':
    - container_web