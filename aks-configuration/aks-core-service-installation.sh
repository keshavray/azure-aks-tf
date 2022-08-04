az login --service-principal --username $servicePrincipalId --password $servicePrincipalKey --tenant $tenantId
#az aks get-credentials --resource-group cp-aks-rg-eaus-prd --name cp-aks-k8s-1-eaus-prd --overwrite-existing
az aks get-credentials --resource-group cp-aks-1-rg-eaus-$ENV --name cp-aks-1-k8s-eaus-$ENV --overwrite-existing --file $(pwd)/.kube/config

brew install Azure/kubelogin/kubelogin

export KUBECONFIG=$(pwd)/.kube/config
kubelogin convert-kubeconfig -l spn
export AAD_SERVICE_PRINCIPAL_CLIENT_ID=$servicePrincipalId
export AAD_SERVICE_PRINCIPAL_CLIENT_SECRET=$servicePrincipalKey

#AAD Pod Identity Install
helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
helm repo update
helm upgrade --install aad-pod-identity aad-pod-identity/aad-pod-identity --namespace=kube-system

#AppGW Ingress Install
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
helm repo update
helm upgrade --install ingress-azure -f ./aks-configuration/$ENV-appgw-helm-config.yml application-gateway-kubernetes-ingress/ingress-azure --version 1.3.0