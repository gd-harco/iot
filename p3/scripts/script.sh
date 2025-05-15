#!/bin/bash

function install_docker() {
	curl -fsSL https://get.docker.com | sudo sh
	sudo usermod -aG docker $USER
}

function install_k3d() {
	wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
	k3d cluster create argocd-cluster -p 8080:80@loadbalancer
}

function install_kubectl() {
	wget -O kubectl "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	echo "alias k=kubectl" >>$HOME/.bash_rc && source $HOME/.bash_rc
}

function install_argocd_cli() {
  export ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  curl -sSL -o /tmp/argocd-${ARGOCD_VERSION} https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64
  chmod +x /tmp/argocd-${VERSION}
  sudo mv /tmp/argocd-${VERSION} /usr/local/bin/argocd
}

function install_argocd() {
	kubectl create ns argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge --patch '{"data": {"server.insecure": "true"}}'
	kubectl rollout restart deployment argocd-server -n argocd
	kubectl wait --for=condition=Available deploy/argocd-server -n argocd --timeout=60s
	kubectl apply -f ../confs/ingress.yml
}

install_docker
install_kubectl
install_k3d
install_argocd

echo "127.0.0.1	awesome.local" | sudo tee -a /etc/hosts

}