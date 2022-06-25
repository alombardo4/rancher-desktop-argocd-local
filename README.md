# Colima Kubernetes ArgoCD Local Setup

This repo includes some helper scripts, Dockerfiles, and Kubernetes configurations to get a local ArgoCD set up with a local Git server for testing purposes in Colima Kubernetes.

1. Install argocd CLI, colima, kubectl: `brew install colima kubectl`
1. Bootstrap the cluster with ArgoCD and related components: `./configure.sh`