# Inception-of-Things (IoT) - DevOps Project

## Description

This project is a part of a System Administration exercise focusing on the use of K3s and K3d with Vagrant. It also touches on deploying applications using Argo CD and integrating with GitLab (in the bonus part). The exercises are designed to help you understand the basics of Kubernetes, continuous integration, and deployment in a virtualized environment.

This project was made in duo with [Marobert](https://github.com/MariusROBERT). We both made the whole project, and the main branch contain his p1 and p3, with my p2 and bonus part.
Both of our whole project is available on our branches, so you can see the whole project with both of our parts.

## Table of Contents

- [Exercise 1: K3s and Vagrant](#exercise-1-k3s-and-vagrant)
- [Exercise 2: K3s and Three Simple Applications](#exercise-2-k3s-and-three-simple-applications)
- [Exercise 3: K3d and Argo CD](#exercise-3-k3d-and-argo-cd)
- [Bonus: GitLab Integration](#bonus-gitlab-integration)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)

## Exercise 1: K3s and Vagrant

### Description

This exercise involves setting up two virtual machines using Vagrant and installing K3s on them. One machine will act as the server (controller) and the other as the worker (agent).

### Prerequisites

- Vagrant
- VirtualBox or any other Vagrant provider

### Steps

1. Create a Vagrantfile to define the two virtual machines.
2. Configure the machines with the specified IP addresses and hostnames.
3. Install K3s on both machines, one as a server and the other as an agent.
4. Ensure you can connect to both machines via SSH without a password.

### Files

- `p1/Vagrantfile`: Vagrant configuration file.
- `p1/scripts/`: Scripts for setting up the machines.

## Exercise 2: K3s and Three Simple Applications

### Description

This exercices aimes to deploy three web applications on a single virtual machine using K3s. The applications should be accessible based on the HOST used in the request.

### Prerequisites

- K3s installed on a virtual machine

### Steps

1. Set up a virtual machine with K3s in server mode.
2. Deploy three web applications.
3. Configure the applications to be accessible based on the HOST used in the request.

### Files

- `p2/Vagrantfile`: Vagrant configuration file.
- `p2/scripts/`: Scripts for deploying the applications.
- `p2/confs/`: Configuration files for the applications.

## Exercise 3: K3d and Argo CD

### Description

This exercise involves setting up K3d and using Argo CD for continuous integration. We had to push an application image to a [Docker registry](https://hub.docker.com/r/marobert42/inception-of-things), deploy it using Argo CD, and verify the deployment by updating the application version in the GitHub repository.

The whole process, including dependency installation, had to be automated using scripts.

### Prerequisites

- K3d
- Docker
- Argo CD

### Steps

1. Install K3d on your virtual machine.
2. Set up Argo CD and create the necessary namespaces.
3. Configure Argo CD to deploy an application from your GitHub repository.
4. Update the application version in your GitHub repository and verify the deployment.

### Files

- `p3/scripts/`: Scripts for setting up K3d and Argo CD.
- `p3/confs/`: Configuration files for Argo CD and the application.

## Bonus: GitLab Integration

### Description

This bonus exercise involves integrating GitLab into the setup created in Exercise 3. We had to set up a local GitLab instance and configure it to work with our Kubernetes cluster.

### Prerequisites

- GitLab
- Helm (optional)

### Steps

1. Set up the k3d cluster like in part 3.
2. Create a dedicated namespace for GitLab.
3. Install GitLab using the Helm charts.
4. Ensure everything from Exercise 3 works with your local GitLab.

### Files

- `bonus/scripts/`: Scripts for setting up GitLab.
- `bonus/confs/`: Configuration files for GitLab.

## Usage

Inside the bonus folder, input

```bash
./scripts/setup.sh all
```

you can also use one of the folliwing arguments to setup only one part:

- `install` to install all dependencies (docker, k3d, helm, kubectl, argocd)
- `cluster` to setup the k3d cluster
- `gitlab` to setup the gitlab instance and push the application configuration to it
- `argocd` to setup the argocd instance
- `deploy` to deploy the application using argocd

## Technologies Used

- Vagrant
- K3s
- K3d
- Docker
- Kubernetes
- Argo CD
- GitLab (Bonus)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push to your fork.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
