Vagrant.configure('2') do |config|
  # grab Ubuntu 14.04 boxcutter image: https://atlas.hashicorp.com/boxcutter
  config.vm.box = "puppetlabs/centos-7.2-64-nocm" # centos 7
  config.vm.hostname = "vagranthost"
  
  # fix issues with slow dns https://www.virtualbox.org/ticket/13002
  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
  end

  config.vm.synced_folder "saltstack/etc/salt", "/etc/salt"
  config.vm.synced_folder "saltstack/pillar", "/srv/pillar"
  
  config.vm.provision :shell, inline: "touch /tmp/disable_salt_checks"
  
  config.ssh.forward_agent = true

  # Salt Provisioner
  config.vm.provision :salt do |salt|
    salt.install_master = true
   # salt.install_syndic = true
    salt.minion_config = "saltstack/etc/minion_vagrant.yaml"
    #salt.run_highstate = true
    salt.install_type = "git"
    salt.install_args = "v2015.8.8"
    #salt.bootstrap_options = '-d'
    salt.colorize = true
    salt.verbose = true
  end
end
