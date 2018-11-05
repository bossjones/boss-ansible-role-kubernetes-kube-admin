# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant multi machine configuration

require 'yaml'
config_yml = YAML.load_file(File.open(__dir__ + '/vagrant-config.yml'))

NON_ROOT_USER = 'vagrant'.freeze
SWAPSIZE = 1000

Vagrant.configure(2) do |config|
  # set auto update to false if you do NOT want to check the correct additions version when booting this machine
  # config.vbguest.auto_update = true

  config_yml[:vms].each do |name, settings|
    # use the config key as the vm identifier
    config.vm.define(name) do |vm_config|
      config.ssh.insert_key = false
      vm_config.vm.usable_port_range = (2200..2250)

      # This will be applied to all vms

      # Ubuntu
      vm_config.vm.box = settings[:box]

      # Vagrant can share the source directory using rsync, NFS, or SSHFS (with the vagrant-sshfs
      # plugin). Consult the Vagrant documentation if you do not want to use SSHFS.
      # Get's honored normally
      vm_config.vm.synced_folder '.', '/vagrant', disabled: true
      # But not the centos box
      vm_config.vm.synced_folder '.', '/home/vagrant/sync', disabled: true

      # assign an ip address in the hosts network
      vm_config.vm.network 'private_network', ip: settings[:ip]

      vm_config.vm.hostname = settings[:hostname]

      config.vm.provider 'virtualbox' do |v|
        # make sure that the name makes sense when seen in the vbox GUI
        v.name = settings[:hostname]

        # Be nice to our users.
        v.customize ['modifyvm', :id, '--memory', settings[:ram], '--cpus', settings[:cpu]]
        v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
        v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
        # Prevent clock drift, see http://stackoverflow.com/a/19492466/323407
        v.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 10_000]

        v.customize ['modifyvm', :id, '--macaddress1', '5CA1AB1E00' + node[:id]]

        # SOURCE: https://www.virtualbox.org/manual/ch09.html#changenat
        # NOTE:  # do not use 10.x network for NAT ?
        # This command would reserve the network addresses from 192.168.0.0 to 192.168.254.254 for the first NAT network instance of "VM name". The guest IP would be assigned to 192.168.0.15 and the default gateway could be found at 192.168.0.2.
        v.customize ['modifyvm', :id, '--natnet1', "192.168/16"]
      end

      # If you want to create an array where each entry is a single word, you can use the %w{} syntax, which creates a word array:
      # However, notice that the %w{} method lets you skip the quotes and the commas.
      hostname_with_hyenalab_tld = "#{settings[:hostname]}.hyenalab.home"

      aliases = [hostname_with_hyenalab_tld, settings[:hostname]]

      if Vagrant.has_plugin?('vagrant-hostsupdater')
        vm_config.hostsupdater.aliases = aliases
      elsif Vagrant.has_plugin?('vagrant-hostmanager')
        vm_config.hostmanager.enabled = true
        vm_config.hostmanager.manage_host = true
        vm_config.hostmanager.aliases = aliases
      end

        vm_config.vm.provision 'shell', inline: 'ip address', run: 'always' # make user feel good
        vm_config.vm.provision 'file', source: 'hosts', destination: 'hosts'
        # Enable provisioning with a shell script. Additional provisioners such as
        # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
        # documentation for more information about their specific syntax and use.

        # TODO: Get rid of /etc/hosts bash script command
        vm_config.vm.provision 'shell' do |s|
          s.inline = <<-SHELL
            if [ -f /vagrant_bootstrap ]; then
              echo "vagrant_bootstrap EXISTS ALREADY"
              exit 0
            fi

            sudo apt-get -y update
            sudo apt-get -y install python-minimal python-apt
            else
              echo 'swapfile found. No changes made.'
            fi

            DEBIAN_FRONTEND=noninteractive apt-get update; apt-get install -y \
            sudo \
            bash-completion \
            curl \
            git \
            vim \
          ; \
                apt-get update \
          ; \
            DEBIAN_FRONTEND=noninteractive apt-get install -y python-six python-pip \
          ; \
                rm -rf /var/lib/apt/lists/*
          touch /vagrant_bootstrap && \
          chown #{NON_ROOT_USER}:#{NON_ROOT_USER} /vagrant_bootstrap
          SHELL
          s.privileged = true
        end

      vm_config.vm.provision :ansible do |ansible|
        ansible.host_key_checking	= 'false'
        # Disable default limit to connect to all the machines
        ansible.limit = 'all'
        ansible.playbook = 'vagrant_playbook.yml'
        ansible.groups = config_yml[:groups]
        ansible.verbose = 'vvv'
        ansible.extra_vars = {
          deploy_env: 'vagrant'
        }
        # ansible.skip_tags = %w[bootstrap]
        ansible.raw_arguments = ["--forks=10"]
      end
    end
  end
end
