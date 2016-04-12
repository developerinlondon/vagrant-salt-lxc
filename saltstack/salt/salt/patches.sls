# this is needed for line 120 as per https://github.com/saltstack/salt/pull/25231/files
# this can be taken out on a newer release of salt where they add this update.
# but without this the containers wont bootstrap with salt.
patched_lxc_py:
  file.managed:
    - name: /usr/lib/python2.7/site-packages/salt/modules/lxc.py
    - source: salt://lib/lxc.py
    - mode: 755
    - user: root
    - group: root