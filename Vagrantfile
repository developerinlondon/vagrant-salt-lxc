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
    # Relative location of configuration file to use for minion
    # since we need to tell our minion to run in masterless mode
    salt.minion_config = "saltstack/etc/minion_vagrant.yaml"

    # On provision, run state.highstate (which installs packages, services, etc).
    # Highstate basicly means "comapre the VMs current machine state against 
    # what it should be and make changes if necessary".
    salt.run_highstate = true
    #salt.install_master = true
    #salt.install_syndic = true

    # What version of salt to install, and from where.
    # Because by default it will install the latest, its better to explicetly
    # choose when to upgrade what version of salt to use.

    # I also prefer to install from git so I can specify a version.
    salt.install_type = "git"
    salt.install_args = "v2015.8.8"

    salt.colorize = true
    # Run in verbose mode, so it will output all debug info to the console.
    # This is nice to have when you are testing things out. Once you know they
    # work well you can comment this line out.
    salt.verbose = true
  end
end
