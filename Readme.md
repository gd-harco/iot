# Inception of Things — DevOps & Infrastructure as Code

Projet réalisé en binôme dans le cadre du cursus de l'école 42. Il met en pratique le provisionnement d'infrastructures locales, l'administration de clusters Kubernetes et le déploiement d'applications selon une approche GitOps.

## Ce que ce projet démontre

- **Infrastructure as Code** : définition de machines virtuelles avec Vagrant et configuration reproductible de clusters K3s.
- **Conteneurisation et orchestration** : déploiement de workloads Kubernetes, services et règles d'ingress.
- **Automatisation** : scripts de provisionnement et de configuration pour réduire les étapes manuelles.
- **GitOps / Continuous Delivery** : Argo CD synchronise des manifestes depuis un dépôt Git vers un cluster K3d.
- **Intégration d'outils DevOps** : déploiement local de GitLab avec Helm et connexion à Argo CD.
- **Diagnostic d'environnements** : exposition de services et résolution de noms locaux pour tester les applications depuis le poste de travail.

## Parcours du projet

### P1 — Cluster K3s avec Vagrant

Le `Vagrantfile` provisionne deux machines Debian : un nœud serveur K3s et un nœud agent. Le serveur fournit le jeton nécessaire à l'enregistrement du nœud worker.

**Compétences mises en œuvre :** machines virtuelles, adressage réseau privé, provisionnement automatisé et architecture Kubernetes serveur/agent.

```bash
cd p1
vagrant up
```

### P2 — Applications et routage HTTP

Une machine virtuelle héberge K3s et trois applications. Les manifestes Kubernetes déclarent leurs Deployments et Services ; un Ingress distribue le trafic selon le nom d'hôte (`app1.com`, `app2.com`, `app3.com`).

**Compétences mises en œuvre :** ressources Kubernetes, exposition de services, règles d'ingress et configuration de ressources de conteneurs.

```bash
cd p2
bash scripts/setup_P2.sh
```

Le script démarre la machine virtuelle et ajoute les noms d'hôte à `/etc/hosts` (l'édition de ce fichier demande les droits administrateur).

### P3 — K3d et déploiement GitOps avec Argo CD

Cette partie automatise l'installation de Docker, K3d, `kubectl` et Argo CD, puis configure une application Argo CD qui suit les manifestes d'un dépôt Git. Les changements publiés dans le dépôt peuvent ainsi être réconciliés dans le cluster.

**Compétences mises en œuvre :** cluster Kubernetes local dans Docker, configuration d'Argo CD, gestion de manifestes et déploiement continu piloté par Git.

Les scripts d'installation et de configuration se trouvent dans `p3/scripts/` ; les configurations associées sont dans `p3/confs/`.

### Bonus — GitLab, Helm et chaîne GitOps locale

Le bonus étend le cluster K3d avec une instance GitLab déployée par Helm. Le script d'orchestration installe les outils, crée le cluster, configure GitLab et Argo CD, puis déploie une application depuis le dépôt GitLab.

**Compétences mises en œuvre :** Helm, intégration entre forge Git et Argo CD, configuration d'ingress et automatisation d'un environnement DevOps local.

Depuis le répertoire `bonus/` :

```bash
./scripts/setup.sh all
```

Les commandes disponibles sont `install`, `cluster`, `gitlab`, `argo`, `deploy` et `uninstall`. Elles exécutent les étapes individuellement ; `all` enchaîne l'installation, la création du cluster, la configuration de GitLab et Argo CD et le déploiement. Le script nécessite les droits adéquats pour installer des outils système et modifier `/etc/hosts`.

## Technologies

| Domaine | Outils |
| --- | --- |
| Infrastructure locale | Vagrant, VirtualBox |
| Conteneurs et clusters | Docker, Kubernetes, K3s, K3d |
| Déploiement | Argo CD, Helm |
| Forge et configuration | GitLab, YAML, Bash |

## Structure du dépôt

```text
.
├── p1/       # Vagrant et cluster K3s serveur/agent
├── p2/       # K3s, applications, Services et Ingress
├── p3/       # K3d et configuration Argo CD
└── bonus/    # GitLab, Helm, Argo CD et déploiement applicatif
```

## Prérequis

- Linux avec accès Internet et droits `sudo`
- VirtualBox et Vagrant pour P1 et P2
- Docker pour les parties reposant sur K3d (P3 et bonus)
- Ressources suffisantes pour exécuter les machines virtuelles ou les composants du bonus ; GitLab est particulièrement gourmand

Les scripts installent certains outils en les téléchargeant depuis leurs sources amont. Consultez-les avant exécution et vérifiez les ressources disponibles sur votre machine, notamment avant de lancer l'ensemble du bonus.

## Répartition du travail

Projet réalisé en binôme avec [Marobert](https://github.com/MariusROBERT). Sur cette branche, P1 et P3 sont principalement portés par mon binôme, et P2 ainsi que le bonus par moi. Les branches du dépôt présentent les versions complètes réalisées par chacun.

> Projet pédagogique : les déploiements sont destinés à un environnement local de développement et de démonstration, pas à une mise en production.
