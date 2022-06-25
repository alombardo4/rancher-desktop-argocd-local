#! /bin/bash
set -euxo pipefail

trap 'pkill kubectl; kubectl delete ns argocd; exit 1' ERR

kubectl create ns argocd
colima start --kubernetes
command -v nerdctl || colima nerdctl install
nerdctl build . -t git-d -f ./Dockerfile.gitd --namespace k8s.io

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f ./git-server.yaml

ARGOCD_PORT=8080
GIT_PORT=9418
set +e
while ! ARGOCD_ADMIN_PW="$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | /usr/bin/base64 -D)"
do
  echo "Waiting for argocd-initial-admin-secret to be created..."
  sleep 1
done
kubectl --namespace argocd rollout status deployment argocd-server
kubectl --namespace argocd rollout status deployment git-server
set -e
kubectl port-forward -n argocd svc/argocd-server $ARGOCD_PORT:80 &
kubectl port-forward -n argocd svc/git-server $GIT_PORT:$GIT_PORT &
sleep 5

REPO_SUFFIX=$(date '+%H%M%S')

GIT_DIR=$TMPDIR--argo-repo-$REPO_SUFFIX

git clone "git://localhost:$GIT_PORT/repo.git" $GIT_DIR --ipv4

echo "Git Directory: $GIT_DIR"

cd $GIT_DIR && mkdir test && echo $'apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: my-configmap\ndata:\n  key: value' > test/test.configmap.yaml && git add . && git commit -m "Initial commit" && git push --ipv4

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
echo $ARGOCD_ADMIN_PW | pbcopy
