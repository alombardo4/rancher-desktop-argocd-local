# Colima Kubernetes ArgoCD Local Setup

This repo includes some helper scripts, Dockerfiles, and Kubernetes configurations to get a local ArgoCD set up with a local Git server for testing purposes in Colima Kubernetes.

1. Install argocd CLI, colima, kubectl: `brew install argocd colima kubectl`
1. If you don't have `nerdctl` already, install nerdctl alias: `colima nerdctl install`
1. Start kubernetes cluster: `colima start --kubernetes`
1. Build Git server image by running `nerdctl build . -t git-d -f ./Dockerfile.gitd --namespace k8s.io`
1. Configure/install git-server/ArgoCD; and get ArgoCD admin password by running `./configure.sh`