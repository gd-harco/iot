#!/bin/bash

exec_install() {
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
		echo "alias k=kubectl" >> "$HOME/.zshrc"

	fi

}

uninstall() {
	echo "uninstall mode called"

	#### Kubectl ####
	if ! command -v kubectl &>/dev/null; then
		echo "kubectl not installed"
	else
		sudo rm "$(which kubectl)"
		sed '/alias\ k=kubectl/d' "$HOME/.zshrc" > .zshrc.tmp && mv .zshrc.tmp "$HOME/.zshrc"
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
}

if [ "$1" = "install" ]; then
	exec_install
elif [ "$1" = "uninstall" ]; then
	uninstall
else
	echo "please specify install or uninstall"
	exit 1
fi
exit 0
