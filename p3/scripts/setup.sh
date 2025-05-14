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

update_host() {
	print_info "Updating /etc/hosts file..."
	if ! grep -q "127.0.0.1 $1.iot.ft" /etc/hosts; then
		echo "Adding entry to /etc/hosts"
		echo "127.0.0.1 $1.iot.ft" | sudo tee -a /etc/hosts
	else
		:
		print_info "Entry already exists in /etc/hosts, skipping..."
	fi
}

setup() {
	print_section "STARTING SETUP PROCESS"

	# Cluster creation
	print_section "CLUSTER SETUP"
	print_info "Creating k3d cluster 'iotp3'..."
	k3d cluster create -c ./confs/k3d/cluster_config.yaml
	print_success "Cluster created successfully"

	# ArgoCD installation
	print_section "ARGOCD SETUP"
	print_info "Creating namespace 'argocd'..."
	kubectl create namespace argocd

	print_info "Applying ArgoCD installation manifests..."
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

	print_info "Waiting for ArgoCD to be ready..."
	kubectl wait --for=condition=Available deploy/argocd-server --timeout=120s -n argocd

	print_info "Applying ArgoCD configuration..."
	kubectl apply -n argocd -f ./confs/argocd/argocd-cmd-params-cm.yaml

	print_info "Restarting ArgoCD server for changes to take effect..."
	kubectl rollout restart deployment argocd-server -n argocd

	print_info "Waiting for ArgoCD to restart..."
	kubectl wait --for=condition=Available deploy/argocd-server --timeout=120s -n argocd

	print_info "Setting up ingress for ArgoCD..."
	kubectl apply -f ./confs/argocd/ingress.yaml -n argocd

	print_success "Installation complete!"
	print_info "Waiting for ArgoCD to be ready..."
	kubectl wait --for=condition=Available deploy/argocd-server --timeout=120s -n argocd

	update_host "config"

	print_info "ArgoCD should now be available at http://config.iot.ft:8081"

	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d | cat >./password.txt
	print_success "Initial admin password saved to ./password.txt"
}

deploy() {
	print_section "DEPLOYING APPLICATIONS"

	print_info "checkin for submodules..."
	if [ -z "$(ls -A './confs/app')" ]; then
		print_info "Submodule not initialize, initializing"

		git submodule init
		git submodule update
	else
		print_warn "Submodule already initialized"
	fi

	print_info "Creating kubernetes secret"
	kubectl apply -f ./confs/app/ssh.yaml

	print_info "Sending application to ArgoCD"
	kubectl apply -f ./confs/app/application.yaml

	print_info "Waiting for namespace to be created by ArgoCD"
	while ! kubectl get namespace application >/dev/null 2>&1; do
		sleep 1
	done

	print_info "Waiting for deployment to be created by ArgoCD"
	while ! kubectl get deployment app-deployment -n application >/dev/null 2>&1; do
		sleep 1
	done
	kubectl wait --for=condition=Available deployment/app-deployment -n application

	update_host "app"
	print_success "App deployed successfuly, available at http://app.iot.ft:8081"

}

# Export a flag to indicate scripts are being run from the main script
export MAIN_SCRIPT_RUNNING=true

case $1 in
uninstall)
	print_section "STARTING UNINSTALLATION PROCESS"
	bash -c ./scripts/uninstall.sh
	exit 0
	;;
install)
	print_section "STARTING INSTALLATION PROCESS"
	if ! bash -c ./scripts/install.sh; then
		print_error "Installation failed. Please check the logs."
		exit 1
	fi
	exit 0
	;&
setup)
	setup
	;&
deploy)
	deploy
	exit 0
	;;
*)
	print_error "Please specify 'install', 'uninstall', 'setup' or 'deploy'"
	exit 1
	;;
esac
