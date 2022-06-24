# Rancher Desktop ArgoCD Local Setup

This repo includes some helper scripts, Dockerfiles, and Kubernetes configurations to get a local ArgoCD set up with a local Git server for testing purposes in Rancher Desktop.

1. Install [Rancher Desktop](https://rancherdesktop.io/)
1. Set up a Kubernetes cluster running on `containerd`
1. Create namespace in Kubernetes by running `kubectl create namespace argocd`
1. Build Git server image by running `nerdctl build . -t git-d -f ./Dockerfile.gitd --namespace k8s.io`
1. Install Git server in Kubernetes by running `kubectl apply -f ./git-server.yaml -n argocd`
1. Install ArgoCD by running `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
1. Expose ports using Rancher Desktop
1. Wait about 30 seconds to 1 minute for ArgoCD to get set up
1. Configure ArgoCD and get admin password by running `ARGOCD_PORT=<argocd server exposed port> GIT_PORT=<git server exposed port> ./configure-argocd.sh`