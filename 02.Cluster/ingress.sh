REGISTRY_NAME=oneweudevcluacr
SOURCE_REGISTRY=k8s.gcr.io
CONTROLLER_IMAGE=ingress-nginx/controller
CONTROLLER_TAG=v1.2.1
PATCH_IMAGE=ingress-nginx/kube-webhook-certgen
PATCH_TAG=v1.1.1
DEFAULTBACKEND_IMAGE=defaultbackend-amd64
DEFAULTBACKEND_TAG=1.5
 az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$CONTROLLER_IMAGE:$CONTROLLER_TAG --image $CONTROLLER_IMAGE:$CONTROLLER_TAG
 az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$PATCH_IMAGE:$PATCH_TAG --image $PATCH_IMAGE:$PATCH_TAG
 az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG --image $DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG
 helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
 ACR_URL=$REGISTRY_NAME'.azurecr.io'
 helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.1.3 --namespace ingress-basic --create-namespace --set controller.replicaCount=2 --set controller.nodeSelector."kubernetes\.io/os"=linux --set controller.image.registry=$ACR_URL --set controller.image.image=$CONTROLLER_IMAGE --set controller.image.tag=$CONTROLLER_TAG --set controller.image.digest="" --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz --set controller.admissionWebhooks.patch.image.registry=$ACR_URL --set controller.admissionWebhooks.patch.image.image=$PATCH_IMAGE --set controller.admissionWebhooks.patch.image.tag=$PATCH_TAG --set controller.admissionWebhooks.patch.image.digest="" --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux --set defaultBackend.image.registry=$ACR_URL --set defaultBackend.image.image=$DEFAULTBACKEND_IMAGE --set defaultBackend.image.tag=$DEFAULTBACKEND_TAG --set defaultBackend.image.digest="" 
 #--set controller.IngressClassResource.name=external-nginx --set controller.IngressClassResource.controllerValue=k8s.io/internal-ingress-nginx
 # helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.1.3 --namespace ingress-basic --create-namespace --set controller.replicaCount=2 --set controller.nodeSelector."kubernetes\.io/os"=linux --set controller.image.registry=$ACR_URL --set controller.image.image=$CONTROLLER_IMAGE --set controller.image.tag=$CONTROLLER_TAG --set controller.image.digest="" --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz --set controller.admissionWebhooks.patch.image.registry=$ACR_URL --set controller.admissionWebhooks.patch.image.image=$PATCH_IMAGE --set controller.admissionWebhooks.patch.image.tag=$PATCH_TAG --set controller.admissionWebhooks.patch.image.digest="" --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux --set defaultBackend.image.registry=$ACR_URL --set defaultBackend.image.image=$DEFAULTBACKEND_IMAGE --set defaultBackend.image.tag=$DEFAULTBACKEND_TAG --set defaultBackend.image.digest="" -f internal-ingress.yaml