function install_docker() {
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl -y
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update

	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	sudo usermod -aG docker $USER
}

function install_k3d() {
	wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
	k3d cluster create argocd-cluster -p 8080:80@loadbalancer
}

function install_kubectl() {
	wget -O kubectl "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	echo "alias k=kubectl" >> $HOME/.bash_rc && source $HOME/.bash_rc
}

function install_argocd() {
	kubectl create ns argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge --patch '{"data": {"server.insecure": "true"}}'
	#kubectl apply -f ../manifests/argocd-cmd-params-cm.yaml
	kubectl rollout restart deployment argocd-server -n argocd
	kubectl wait --for=condition=Available deploy/argocd-server -n argocd --timeout=60s
}

install_docker
install_kubectl
install_k3d
install_argocd

echo "127.0.0.1	awesome.local" | sudo tee -a /etc/hosts
