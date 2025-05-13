#!/bin/bash
set -e
# Check if this script is being run from the main script
if [ -z "$MAIN_SCRIPT_RUNNING" ]; then
  echo -e "\033[0;31m[ERROR]\033[0m This script should only be run through the main deployment script."
  echo -e "\033[0;33m[INFO]\033[0m Please run: ./scripts/setup.sh install"
  exit 1
fi

# Functions and colors are inherited from the main script

print_section "INSTALL MODE INITIATED"

#### DOCKER INSTALLATION ####
print_section "DOCKER SETUP"
if command -v docker &>/dev/null; then
  print_info "Docker already installed, skipping..."
else
  print_info "Installing Docker..."
  curl -fsSL https://get.docker.com | sudo sh

  print_info "Creating docker group and adding $USER to it..."
  sudo groupadd docker 2>/dev/null || true
  sudo usermod -aG docker "$USER"

  print_warn "Docker installed. You'll need to log out and log back in to use Docker without sudo"
  print_success "Docker installation complete"
fi

#### K3D INSTALLATION ####
print_section "K3D SETUP"
if command -v k3d &>/dev/null; then
  print_info "k3d already installed, skipping..."
else
  print_info "Installing k3d..."
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sudo bash
  print_success "k3d installation complete"
fi

#### KUBECTL INSTALLATION ####
print_section "KUBECTL SETUP"
if command -v kubectl &>/dev/null; then
  print_info "kubectl already installed, skipping..."
else
  print_info "Downloading kubectl..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

  print_info "Installing kubectl..."
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/

  print_info "Adding kubectl alias to .zshrc..."
  echo "alias k=kubectl" >>"$HOME/.zshrc"

  print_success "kubectl installation complete"
fi

print_success "All components installed successfully"
