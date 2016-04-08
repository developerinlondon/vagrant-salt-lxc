base:
  '2usvretzer.ad.here.com':
    - common
    - salt
    - lxc

  'redis':
    - common
    - container_redis
  'web':
    - common
    - container_web