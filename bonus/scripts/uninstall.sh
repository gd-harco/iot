#!/bin/bash
set -e
# Check if this script is being run from the main script
if [ -z "$MAIN_SCRIPT_RUNNING" ]; then
  echo -e "\033[0;31m[ERROR]\033[0m This script should only be run through the main deployment script."
  echo -e "\033[0;33m[INFO]\033[0m Please run: ./scripts/setup.sh uninstall"
  exit 1
fi

# Functions and colors are inherited from the main script

print_section "UNINSTALL MODE INITIATED"

#### HELM REMOVAL ####
print_section "HELM REMOVAL"
if ! command -v helm &>/dev/null; then
  print_warn "helm not found - skipping removal"
else
  print_info "Removing helm..."
  sudo rm "$(which helm)"

  print_success "helm successfully removed"
fi

#### KUBECTL REMOVAL ####
print_section "KUBECTL REMOVAL"
if ! command -v kubectl &>/dev/null; then
  print_warn "kubectl not found - skipping removal"
else
  print_info "Removing kubectl..."
  sudo rm "$(which kubectl)"

  print_success "kubectl successfully removed"
fi

#### K3D REMOVAL ####
print_section "K3D REMOVAL"
if ! command -v k3d &>/dev/null; then
  print_warn "k3d not found - skipping removal"
else
  print_info "Deleting all k3d clusters..."
  k3d cluster delete -a

  print_info "Removing k3d..."
  sudo rm "$(which k3d)"

  print_success "k3d successfully removed"
fi

#### DOCKER REMOVAL ####
print_section "DOCKER REMOVAL"
if ! command -v docker &>/dev/null; then
  print_warn "Docker not found - skipping removal"
else
  print_info "Removing Docker packages..."
  sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y

  print_info "Cleaning Docker directories and files..."
  sudo rm -rf /var/lib/docker
  sudo rm -rf /var/lib/containerd
  sudo rm -f /etc/apt/sources.list.d/docker.list
  sudo rm -f /etc/apt/keyrings/docker.asc

  print_info "Removing Docker group..."
  sudo groupdel docker

  print_success "Docker successfully removed"
fi

print_section "CLEANING UP"

print_info "removing alias from .zshrc..."
sed '/alias\ k=kubectl/d' "$HOME/.zshrc" >.zshrc.tmp && mv .zshrc.tmp "$HOME/.zshrc"

print_info "cleaning up hosts file..."
if grep -q "127.0.0.1 config.iot.ft" /etc/hosts; then
  sudo sed -i '/127.0.0.1\ config.iot.ft/d' /etc/hosts
fi
if grep -q "127.0.0.1 app.iot.ft" /etc/hosts; then
  sudo sed -i '/127.0.0.1\ app.iot.ft/d' /etc/hosts
fi
print_success "Hosts file cleaned up"

print_info "removing old password file"
rm ./password.txt

print_success "Uninstallation process completed successfully"
