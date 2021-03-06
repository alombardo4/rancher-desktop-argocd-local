#! /bin/bash


REPO_SUFFIX=$(date '+%H%M%S')

GIT_DIR=$TMPDIR--argo-repo-$REPO_SUFFIX

git clone "git://localhost:$GIT_PORT/repo.git" $GIT_DIR

echo "Git Directory: $GIT_DIR"

cd $GIT_DIR && mkdir test && echo $'apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: my-configmap\ndata:\n  key: value' > test/test.configmap.yaml && git add . && git commit -m "Initial commit" && git push

ARGOCD_ADMIN_PW=$(kubectl get secret argocd-initial-admin-secret -n argocd -o json | jq '.data.password' -r | base64 -D)

BEARER_TOKEN=$(curl --insecure --fail --silent "https://localhost:${ARGOCD_PORT}/api/v1/session" -d "{\"username\":\"admin\",\"password\":\"${ARGOCD_ADMIN_PW}\"}" | jq -r '.token')


curl --insecure --fail "https://localhost:${ARGOCD_PORT}/api/v1/repositories" -H "Authorization: Bearer $BEARER_TOKEN" -d "{\"type\":\"git\",\"repo\":\"git://git-server:9418/repo.git\"}"
echo
echo
echo 'Done!'
echo 
echo "To make changes for ArgoCD to pick up, open the Git repository locally at: $GIT_DIR"
echo
echo "Set up your application in the ArgoCD UI at https://localhost:$ARGOCD_PORT"
echo
echo "ArgoCD Admin Password: $ARGOCD_ADMIN_PW"