#!/bin/bash
set -e
# Define color codes for different information levels
export INFO='\033[0;32m'    # Green for standard information
export WARN='\033[0;33m'    # Yellow for warnings
export ERROR='\033[0;31m'   # Red for errors
export SUCCESS='\033[0;36m' # Cyan for success messages
export RESET='\033[0m'      # Reset color

# Function to print formatted messages
print_info() {
	echo -e "${INFO}[INFO]${RESET} $1"
}
export -f print_info

print_warn() {
	echo -e "${WARN}[WARNING]${RESET} $1"
}
export -f print_warn

print_error() {
	echo -e "${ERROR}[ERROR]${RESET} $1"
}
export -f print_error

print_success() {
	echo -e "${SUCCESS}[SUCCESS]${RESET} $1"
}
export -f print_success

print_section() {
	echo -e "\n${SUCCESS}==== $1 ====${RESET}"
}
export -f print_section

# Export a flag to indicate scripts are being run from the main script
export MAIN_SCRIPT_RUNNING=true

# Check command line arguments
if [ "$1" = "install" ]; then
	print_section "STARTING INSTALLATION PROCESS"
	if ! bash -c ./script/install.sh; then
		print_error "Installation failed. Please check the logs."
		exit 1
	fi
elif [ "$1" = "uninstall" ]; then
	print_section "STARTING UNINSTALLATION PROCESS"
	bash -c ./script/uninstall.sh
	exit 0
else
	print_error "Please specify 'install' or 'uninstall'"
	exit 1
fi

# Cluster creation
print_section "CLUSTER SETUP"
print_info "Creating k3d cluster 'iotp3'..."
k3d cluster create iotp3 --api-port 6550 -p "8081:80@loadbalancer"
print_success "Cluster created successfully"

# ArgoCD installation
print_section "ARGOCD SETUP"
print_info "Creating namespace 'argocd'..."
kubectl create namespace argocd

print_info "Applying ArgoCD installation manifests..."
kubectl apply -n argocd -f ./argocd/install.yaml

print_info "Applying ArgoCD configuration..."
kubectl apply -n argocd -f ./argocd/argocd-cmd-params-cm.yaml

print_info "Restarting ArgoCD server for changes to take effect..."
kubectl rollout restart deployment argocd-server -n argocd

print_info "Setting up ingress for ArgoCD..."
kubectl apply -f ./argocd/ingress.yaml -n argocd

print_success "Installation complete!"
print_info "ArgoCD should now be available at http://localhost:8081"
exit 0
