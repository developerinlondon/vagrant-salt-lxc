base:
  '*':
    - common
  'vagranthost':
    - salt
    - lxc
#    - ssh-config
#    - gitfs
  'container_redis':
    - container_redis
  'container_web':
    - container_web
    - repo