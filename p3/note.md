### creer le cluster k3d
```bash
k3d cluster create iotp3 --api-port 6550 -p "8081:80@loadbalancer"
```

### creer le namespace pour argocd
```bash
kubectl create namespace argocd
```

### installer argocd [^1]
```bash
kubectl apply -n argocd -f ./argocd/install.yaml
```

### appliquer la configMap pour autoriser l'acces en http [^2]
```bash
kubectl apply -n argocd -f ./argocd/argocd-cmd-params-cm.yaml
```

### redemarrer le pod argocd-server
```bash
kubectl rollout restart deployment argocd-server -n argocd
```

### Installer l'ingress traefik
```bash
kubectl apply -f ./argocd/ingress.yaml
```

Argocd devrait etre accessible sur l'url suivante : [http://localhost:8081/](http://localhost:8081/) (un peu de patience, le temps que le pod argocd-server redemarre)



[^1]: On utilise le manifest d'installation [recupere depuis le site officiel d'argocd ](https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/)

[^2]: [source](https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#traefik-v30/)
