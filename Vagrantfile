# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "debian/bookworm64"
  # config.vm.box_version = "8.11.1"

  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false

    vb.memory = "512"
  end

  config.vm.define "marobert" do |server|
    server.vm.hostname = "marobertS"
    server.vm.network "private_network", ip: "192.168.56.110"

    server.vm.provision "shell", name: "install-k3s-server", inline: <<-SHELL
      #apt update
      # apt install curl -y
      # curl -sfL https://get.k3s.io | sh -
      wget -qO - https://get.k3s.io | sh -
      sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
    SHELL
  end

  config.vm.define "jrenault" do |agent|
    agent.vm.hostname = "marobertSW"
    agent.vm.network "private_network", ip: "192.168.56.111"

    agent.vm.provision "shell", name: "install-k3s-node", inline: <<-SHELL
      for i in {1..30}; do
        if K3S_URL=$(getent hosts marobertS.local | awk '{print $1}'); then
          break
        fi
        echo "Waiting for marobertS.local to be resolvable..."
        sleep 2
      done

      while [ ! -f /vagrant/node-token]; do
        sleep 2
      done

      K3S_TOKEN=`cat /vagrant/node-token`

      wget -qO - https://get.k3s.io | sh - 
    SHELL
  end

  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
