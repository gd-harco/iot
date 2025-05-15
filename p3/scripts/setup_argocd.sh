#!/bin/bash

function setup_argocd() {
	ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
	argocd login --username admin --password $ARGOCD_PASSWORD --insecure --plaintext --grpc-web localhost:8080

	kubectl create ns dev

	argocd app create awesome-app \
		--repo https://github.com/Inception-of-things/jubilant-goggles-marobert \
		--path . \
		--dest-namespace dev \
		--dest-server https://kubernetes.default.svc \
		--directory-recurse \
		--sync-policy automated

}

setup_argocd
