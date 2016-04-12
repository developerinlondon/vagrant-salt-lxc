python_packages:
  pkg.installed:
    - names:
      - python-devel
      - mariadb
      - mariadb-devel
      - mariadb-libs
      - mariadb-server
      - gcc
    - required_by:
      - pip: pip_packages

pip_packages:
  pip.installed:
    - names:
      - django
      - mysql-python
    - require:
      - pkg: python-pip