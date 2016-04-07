Vagrant.configure('2') do |config|
  # grab Ubuntu 14.04 boxcutter image: https://atlas.hashicorp.com/boxcutter
  config.vm.box = "puppetlabs/centos-7.2-64-nocm" # centos 7

  # fix issues with slow dns https://www.virtualbox.org/ticket/13002
  config.vm.provider :virtualbox do |vb, override|
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
  end

  #config.vm.synced_folder "saltstack", "/saltstack"

  # Salt Provisioner
  config.vm.provision :salt do |salt|
    salt.minion_config = "saltstack/etc/minion_vagrant.yaml"
    salt.run_highstate = true
    salt.install_type = "git"
    salt.install_args = "v2015.8.8"
    salt.colorize = true
    salt.verbose = true
  end

  config.vm.provision "shell", inline: "sudo salt '*' state.highstate"
end
