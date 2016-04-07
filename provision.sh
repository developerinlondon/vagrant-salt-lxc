/vagrant/bootstrap_salt.sh -P -M -S -L git v2015.8.8
cp /vagrant/saltstack/etc/salt/* /etc/salt/
service salt-master restart
service salt-minion restart
