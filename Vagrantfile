# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rbconfig'
VAGRANT_BOX = 'centos/7'

Vagrant.configure("2") do |config|

  config.vm.box = VAGRANT_BOX

  vms = [
    { :name => "webapp1-cars",    :priv_ip => "10.10.10.100" },
    { :name => "webapp2-snake",   :priv_ip => "10.10.10.200" },
    { :name => "ansible-control", :priv_ip => "10.10.10.10" }
  ]

  config.vm.provider "virtualbox" do |vm|
    vm.cpus = 1
    vm.memory = "1024"
    vm.linked_clone = true
    vm.check_guest_additions = false
  end

  vms.each do |vm|
    config.vm.define vm[:name] do |config|
      config.ssh.insert_key = false
      config.vm.hostname = vm[:name]
      config.vm.network :private_network, ip: vm[:priv_ip], hostname: true
    end # config.vm.define
  end # vms.each

  files = [
    { :source => "~/.vagrant.d/insecure_private_key", :destination => "~/.ssh/id_rsa"             },
    { :source => "./inventory",                       :destination => "~/inventory"               },
    { :source => "./ansible.cfg",                     :destination => "~/ansible.cfg"             },
    { :source => "./configure.yml",                   :destination => "~/configure.yml"           },
    { :source => "./templates/car.html.j2",           :destination => "~/templates/car.html.j2"   },
    { :source => "./templates/snake.html.j2",         :destination => "~/templates/snake.html.j2" },
    { :source => "./templates/chrony.conf.j2",        :destination => "~/templates/chrony.conf.j2"}
  ]

  # provision all vms
  vms.each do |vm|
    config.vm.define vm[:name] do |config|
      if vm[:name] == "ansible-control"
        # preparing ansible server
        config.vm.provision :shell, path: "ansible.sh", privileged: true
        # copying files to ansible control node
        files.each do |file|
          config.vm.provision "file", source: file[:source], destination: file[:destination]
        end # file copy
        config.vm.provision :shell, inline: "chmod 600 ~/.ssh/id_rsa", privileged: false
      end # if
    end # config.vm.define
  end # vms.each

  # preparing control node and running ansible scripts
  # using: https://developer.hashicorp.com/vagrant/docs/provisioning/ansible_local
  vms.each do |vm|
    config.vm.define vm[:name] do |config|
      if vm[:name] == "ansible-control"
        config.vm.provision "ansible_local" do |ansible|
          ansible.playbook = "configure.yml"
          ansible.become = true
          ansible.limit = ["webapp1-cars", "webapp2-snake"]
          ansible.inventory_path = "inventory"
          ansible.galaxy_role_file = "roles.yml"
          ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
        end # ansible
      end # if
    end # config.vm.define
  end # vms.each

end # vagrant configure
