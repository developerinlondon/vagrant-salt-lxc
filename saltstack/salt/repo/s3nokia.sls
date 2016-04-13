/etc/yum/pluginconf.d/nokia-s3yum.conf:
  file.managed:
    - source: salt://repo/files/nokia-s3yum.conf
    - mode: 644

/usr/lib/yum-plugins/nokia-s3yum.py:
  file.managed:
    - source: salt://repo/files/nokia-s3yum.py
    - mode: 644

/etc/yum.repos.d/datalens.repo:
  file.managed:
    - source: salt://repo/files/datalens.repo
    - mode: 644
