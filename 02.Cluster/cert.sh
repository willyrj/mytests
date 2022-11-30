	
REGISTRY_NAME=oneweudevcluacr
CERT_MANAGER_REGISTRY=quay.io
CERT_MANAGER_TAG=v1.8.0
CERT_MANAGER_IMAGE_CONTROLLER=jetstack/cert-manager-controller
CERT_MANAGER_IMAGE_WEBHOOK=jetstack/cert-manager-webhook
CERT_MANAGER_IMAGE_CAINJECTOR=jetstack/cert-manager-cainjector
CERT_MANAGER_IMAGE_CTL=jetstack/cert-manager-ctl
az acr import --name $REGISTRY_NAME --source $CERT_MANAGER_REGISTRY/$CERT_MANAGER_IMAGE_CONTROLLER:$CERT_MANAGER_TAG --image $CERT_MANAGER_IMAGE_CONTROLLER:$CERT_MANAGER_TAG
az acr import --name $REGISTRY_NAME --source $CERT_MANAGER_REGISTRY/$CERT_MANAGER_IMAGE_WEBHOOK:$CERT_MANAGER_TAG --image $CERT_MANAGER_IMAGE_WEBHOOK:$CERT_MANAGER_TAG
az acr import --name $REGISTRY_NAME --source $CERT_MANAGER_REGISTRY/$CERT_MANAGER_IMAGE_CAINJECTOR:$CERT_MANAGER_TAG --image $CERT_MANAGER_IMAGE_CAINJECTOR:$CERT_MANAGER_TAG
az acr import --name $REGISTRY_NAME --source $CERT_MANAGER_REGISTRY/$CERT_MANAGER_IMAGE_CTL:$CERT_MANAGER_TAG --image $CERT_MANAGER_IMAGE_CTL:$CERT_MANAGER_TAG

ACR_URL=$REGISTRY_NAME'.azurecr.io'
kubectl label namespace ingress-basic cert-manager.io/disable-validation=true
helm repo add jetstack https://charts.jetstack.io
helm repo update


helm install cert-manager jetstack/cert-manager --namespace ingress-basic --version $CERT_MANAGER_TAG --set installCRDs=true --set nodeSelector."kubernetes\.io/os"=linux --set image.repository=$ACR_URL/$CERT_MANAGER_IMAGE_CONTROLLER --set image.tag=$CERT_MANAGER_TAG --set webhook.image.repository=$ACR_URL/$CERT_MANAGER_IMAGE_WEBHOOK --set webhook.image.tag=$CERT_MANAGER_TAG --set cainjector.image.repository=$ACR_URL/$CERT_MANAGER_IMAGE_CAINJECTOR --set cainjector.image.tag=$CERT_MANAGER_TAG --set ctl.image.repository=$ACR_URL/$CERT_MANAGER_IMAGE_CTL --set ctl.image.tag=$CERT_MANAGER_TAG
	            
# kubectl apply -f ./issuer.yaml