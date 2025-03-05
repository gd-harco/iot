# -*- mode: ruby -*-
# vi: set ft=ruby :

=begin
To begin, you have to set up 2 machines.

Write your first Vagrantfile using the latest stable version of the distribution
of your choice as your operating system. It is STRONGLY advised to allow only the
bare minimum in terms of resources: 1 CPU, 512 MB of RAM (or 1024).


The machines must be run using Vagrant.

Here are the expected specifications:
• The machine names must be the login of someone of your team. The hostname
of the first machine must be followed by the capital letter S (like Server). The
hostname of the second machine must be followed by SW (like ServerWorker).
• Have a dedicated IP on the eth1 interface. The IP of the first machine (Server)
will be 192.168.56.110, and the IP of the second machine (ServerWorker) will be
192.168.56.111.
• Be able to connect with SSH on both machines with no password.
You will set up your Vagrantfile according to modern practices.
You must install K3s on both machines:
• In the first one (Server), it will be installed in controller mode.
• In the second one (ServerWorker), in agent mode.
You will have to use kubectl (and therefore install it too).
=end


SERVICES = {
  'gd-harcoS' => {
    ip: '192.168.56.110',
    # ports: { 6379 => 6379 }
  },
  'gd-harcoSW' => {
    ip: '192.168.56.111',
    # ports: { 8080 => 8080 }
  }
}

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "debian/bookworm64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.define "gd-harcoS" do |server|
    server.vm.hostname = "gd-harcoS"
    server.vm.network "private_network", ip: SERVICES['gd-harcoS'][:ip]
    server.vm.provider "virtualbox" do |v|
      v.name = "gd-harcoS"
    end
  end

  config.vm.define "gd-harcoSW" do |worker|
    worker.vm.hostname = "gd-harcoSW"
    worker.vm.network "private_network", ip: SERVICES['gd-harcoSW'][:ip]
    worker.vm.provider "virtualbox" do |v|
      v.name = "gd-harcoSW"
    end
  end

end
