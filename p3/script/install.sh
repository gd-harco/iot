#!/bin/bash

echo "Install mode called"

#### docker ####
if command -v docker &>/dev/null; then
	echo "Docker already installed, skipping..."
else
	echo "Installing Docker"
	curl -fsSL https://get.docker.com | sudo sh
	echo "Creating docker groups and adding $USER to it"
	sudo groupadd docker 2>/dev/null || true
	sudo usermod -aG docker "$USER"
	echo "Docker should be installed properly. Please log out and login to be able to use docker without sudo"
fi

#### K3D ####
if command -v k3d &>/dev/null; then
	echo "k3d already installed, skipping"
else
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sudo bash
fi

#### Kubectl ####
if command -v kubectl &>/dev/null; then
	echo "kubectl already installed, skipping"
else
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x kubectl
	sudo mv kubectl /usr/local/bin/
	echo "alias k=kubectl" >>"$HOME/.zshrc"

fi
