#!/bin/bash

echo "uninstall mode called"

#### Kubectl ####
if ! command -v kubectl &>/dev/null; then
	echo "kubectl not installed"
else
	echo "prout"
	sudo rm "$(which kubectl)"
	sed '/alias\ k=kubectl/d' "$HOME/.zshrc" >.zshrc.tmp && mv .zshrc.tmp "$HOME/.zshrc"
fi

#### K3D ####
if ! command -v k3d &>/dev/null; then
	echo "k3d not installed"
else
	k3d cluster delete -a
	sudo rm "$(which k3d)"
fi

#### Docker Removal ####
if ! command -v docker &>/dev/null; then
	echo "Docker is not installed, skipping"
else
	sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y
	sudo rm -rf /var/lib/docker
	sudo rm -rf /var/lib/containerd
	sudo rm /etc/apt/sources.list.d/docker.list
	sudo rm /etc/apt/keyrings/docker.asc
	sudo groupdel docker

	echo "Docker uninstalled"
fi
