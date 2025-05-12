function install_docker() {
	# Add Docker's official GPG key:
	apt-get update
	apt-get install ca-certificates curl -y
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  tee /etc/apt/sources.list.d/docker.list > /dev/null
	apt-get update

	apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}

function install_k3d() {
	wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
}

function install_kubectl() {
	wget -O kubectl "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	echo "alias k=kubectl" >> $HOME/.bash_rc && source $HOME/.bash_rc
}

install_docker
install_k3d
install_kubectl

k3d cluster create argocd-cluster -p 8080:80@loadbalancer
kubectl apply -f ../ingress.yml
kubectl apply -f ../argocd-cmd-params-cm.yaml
kubectl rollout restart deployment argocd-server -n argocd
kubectl wait --for=condition=Available deploy/argocd-server -n argocd
ARGOCD_PASSWORD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
argocd login --username admin --password $ARGOCD_PASSWORD --insecure --plaintext --grpc-web localhost:8080

kubectl create ns dev

argocd app create awesome-app \
        --repo https://github.com/Inception-of-things/jubilant-goggles \
        --path . \
        --dest-namespace dev \
        --dest-server https://kubernetes.default.svc \
        --directory-recurse
