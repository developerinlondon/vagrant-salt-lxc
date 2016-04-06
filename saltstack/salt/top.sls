base:
  'vagranthost':
    - common
    - salt
#    - containers
    - lxc
  'redis':
    - redis
  'web':
    - nginx