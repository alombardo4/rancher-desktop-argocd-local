# Colima Kubernetes ArgoCD Local Setup

This repo includes some helper scripts, Dockerfiles, and Kubernetes configurations to get a local ArgoCD set up with a local Git server for testing purposes in Colima Kubernetes.

1. Install colima: `brew install colima`
1. Start kubernetes cluster: `colima start --kubernetes`
1. If you don't have `nerdctl` already, install nerdctl alias: `colima nerdctl install`
1. Create namespace in Kubernetes by running `kubectl create ns argocd`
1. Install ArgoCD by running `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
1. Build Git server image by running `nerdctl build . -t git-d -f ./Dockerfile.gitd --namespace k8s.io`
1. Install Git server in Kubernetes by running `kubectl apply -f ./git-server.yaml -n argocd`
1. Wait about 30 seconds to 1 minute for ArgoCD to get set up
1. Configure ArgoCD and get admin password by running `./configure-argocd.sh`