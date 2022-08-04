# Azure Active Directory (AAD) Pod Identity

To enable access from AKS to azure resources we are using AAD pod identity.  See link for more information.

https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-identity#use-pod-identities

### Pre-requisites

* AD managed AKS

AKS Cluster needs to be managed by Active directory.  Any groups or accounts that need to manage AKS need to be added to the admin groups object

On AKS Cluster to Allow 
 azure_active_directory {
          managed = true
          admin_group_object_ids = ["f76e5a84-7bd6-4a3b-adcb-b7e5f33c16d1", "f938b130-152f-4fb8-ba53-57b1510fa781"]
      }

* Permissions

The Managed Identity used by the AKS cluster needs to have the following permissions;

"Managed Identity Operator" 
"Virtual Machine Contributor"

These role permissions are added in terraform at the bottom of aks.tf. See link for more information;

https://github.com/Azure/aad-pod-identity/blob/master/docs/readmes/README.role-assignment.md

To find the MI AKS role ID you can use this command

```
AKS cluster with managed identity	az aks show -g <AKSResourceGroup> -n <AKSClusterName> --query identityProfile.kubeletidentity.clientId -otsv
```

* TF version

As per the issue here to apply the AD changes to the AKS template to enable AD integration we needed to update the Azure RM provide to 2.21.0

https://github.com/terraform-providers/terraform-provider-azurerm/issues/7325 

## Configuring the cluster

As per this document we used the helm chart to deploy AAD managed identities to the cluster https://github.com/Azure/aad-pod-identity

helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts we did deploy this to the kube-system namespace as per the commands below

```
#Install the aad pod identity services into the kube-system namespace
helm install aad-pod-identity aad-pod-identity/aad-pod-identity -n kube-system
```

After this point each Application will need an identity with the correct permission to access Azure resources.  The Managed identity and role permissions that are required will need to be added, this can be done with terraform.  Identity.tf is an example which can be deleted or replaced and new ones added per app.

Then on a per app basis you will need an AzureIdentity and AzureIdentityBinding as per the below examples.  You can add templates do do this in the Helm chart templates for Azure.

```Yaml
cat <<EOF | kubectl apply -f -
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  name: $IDENTITY_NAME
spec:
  type: 0
  resourceID: $IDENTITY_RESOURCE_ID
  clientID: $IDENTITY_CLIENT_ID
EOF
```

```Yaml
cat <<EOF | kubectl apply -f -
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  name: $IDENTITY_NAME-binding
spec:
  azureIdentity: $IDENTITY_NAME
  selector: $IDENTITY_NAME
EOF
```

Each pod you deploy can then if required reference this identity to be able to get an auth token to access Azure resources.

```Yaml
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: demo
  labels:
    aadpodidbinding: $IDENTITY_NAME
spec:
  containers:
  - name: demo
    image: mcr.microsoft.com/k8s/aad-pod-identity/demo:1.2
    args:
      - --subscriptionid=$SUBSCRIPTION_ID
      - --clientid=$IDENTITY_CLIENT_ID
      - --resourcegroup=$RESOURCE_GROUP
    env:
      - name: MY_POD_NAME
        valueFrom:
          fieldRef:
            fieldPath: metadata.name
      - name: MY_POD_NAMESPACE
        valueFrom:
          fieldRef:
            fieldPath: metadata.namespace
      - name: MY_POD_IP
        valueFrom:
          fieldRef:
            fieldPath: status.podIP
  nodeSelector:
    kubernetes.io/os: linux
EOF
```