kubectl create namespace admin
kubectl create serviceaccount devops-kubernetes-svc -n  admin
kubectl apply -f role.yaml
kubectl apply -f rolebinding.yaml
kubectl config view --minify -o 'jsonpath={.clusters[0].cluster.server}'
NOMBRE=$(kubectl get serviceAccounts devops-kubernetes-svc -n admin 'jsonpath={.secrets[*].name}')
kubectl get secret $NOMBRE -n admin -o json >  secret.json